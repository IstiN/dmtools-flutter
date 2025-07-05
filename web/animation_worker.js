// This script runs in a separate thread and handles the animation logic.

let canvas;
let ctx;
const numberOfDots = 36;
let dotStates = [];

// Easing functions
function lerp(start, end, t) { return start * (1 - t) + end * t; }
function lerpPoint(p1, p2, t) { return { x: lerp(p1.x, p2.x, t), y: lerp(p1.y, p2.y, t) }; }
function easeOut(t) { return 1 - Math.pow(1 - t, 3); }
function easeIn(t) { return t * t * t; }
function easeInOut(t) { return t < 0.5 ? 4 * t * t * t : 1 - Math.pow(-2 * t + 2, 3) / 2; }

// Calculates the target position of a dot in the final DNA structure
function calculateDnaPositionForDot(i, size, center) {
    const halfDots = Math.floor(numberOfDots / 2);
    const isTopStrand = i < halfDots;
    const dotOnStrand = isTopStrand ? i : i - halfDots;
    const horizontalProgress = halfDots > 1 ? dotOnStrand / (halfDots - 1) : 0.5;
    const x = size.width * (horizontalProgress - 0.5);
    const waveAngle = horizontalProgress * Math.PI * 3;
    const y = size.height / 2 * Math.sin(waveAngle);
    return { x: center.x + x, y: center.y + (isTopStrand ? y : -y) };
}

// Initialize dot states with random positions and velocities
function initializeDots(size, center) {
  dotStates = [];
  for (let i = 0; i < numberOfDots; i++) {
    dotStates.push({
      x: center.x + (Math.random() - 0.5) * size.width,
      y: center.y + (Math.random() - 0.5) * size.height,
      vx: (Math.random() - 0.5) * 1.5,
      vy: (Math.random() - 0.5) * 1.5,
    });
  }
}

// Update dot positions for chaotic movement
function updateChaoticPositions(size, center) {
  dotStates.forEach(dot => {
    dot.x += dot.vx;
    dot.y += dot.vy;
    if (dot.x < 0 || dot.x > size.width) dot.vx *= -1;
    if (dot.y < 0 || dot.y > size.height) dot.vy *= -1;
  });
}

function draw(time) {
    if (!ctx) return; // Exit if context is not yet available
    const duration = 12000; // 12-second loop
    const t = (time % duration) / duration;
    
    const canvasSize = { width: canvas.width, height: canvas.height };
    const center = { x: canvas.width / 2, y: canvas.height / 2 };

    ctx.clearRect(0, 0, canvas.width, canvas.height);

    // Define animation phases
    const chaosEndTime = 0.4;
    const gatherEndTime = 0.7;
    const holdEndTime = 0.9;
    
    updateChaoticPositions(canvasSize, center);

    for (let i = 0; i < numberOfDots; i++) {
        const dnaPosition = calculateDnaPositionForDot(i, canvasSize, center);
        const chaoticPosition = {x: dotStates[i].x, y: dotStates[i].y};
        let dotPosition;

        if (t < chaosEndTime) {
            dotPosition = chaoticPosition;
        } else if (t < gatherEndTime) {
            const phaseProgress = (t - chaosEndTime) / (gatherEndTime - chaosEndTime);
            dotPosition = lerpPoint(chaoticPosition, dnaPosition, easeInOut(phaseProgress));
        } else if (t < holdEndTime) {
            dotPosition = dnaPosition;
        } else { // Disperse phase
            const phaseProgress = (t - holdEndTime) / (1.0 - holdEndTime);
            const nextChaoticPosition = {
                x: dotStates[i].x + dotStates[i].vx * 20, // Project outwards
                y: dotStates[i].y + dotStates[i].vy * 20
            };
            dotPosition = lerpPoint(dnaPosition, nextChaoticPosition, easeIn(phaseProgress));
            
            if(phaseProgress > 0.99) {
               initializeDots(canvasSize, center);
            }
        }

        const distance = Math.sqrt(Math.pow(dotPosition.x - center.x, 2) + Math.pow(dotPosition.y - center.y, 2));
        const maxDistance = canvas.width / 2;
        let dotRadius = Math.max(1.0, (canvas.width / 60 * (1 - distance / maxDistance)));
        const opacity = Math.max(0.1, 1.0 - (distance / maxDistance) * 0.7);
        
        ctx.beginPath();
        ctx.arc(dotPosition.x, dotPosition.y, dotRadius, 0, 2 * Math.PI);
        ctx.fillStyle = `rgba(138, 148, 255, ${opacity})`;
        ctx.fill();
    }

    let rungOpacity = 0.0;
    if (t >= chaosEndTime && t < gatherEndTime) {
        rungOpacity = (t - chaosEndTime) / (gatherEndTime - chaosEndTime);
    } else if (t >= gatherEndTime && t < holdEndTime) {
        rungOpacity = 1.0;
    } else if (t >= holdEndTime) {
        rungOpacity = 1.0 - ((t - holdEndTime) / (1.0 - holdEndTime));
    }
    
    if (rungOpacity > 0.0) {
        ctx.strokeStyle = `rgba(138, 148, 255, ${rungOpacity * 0.5})`;
        ctx.lineWidth = 0.8;
        const rungCount = 10;
        for (let j = 0; j < rungCount; j++) {
            const horizontalProgress = (j + 0.5) / rungCount;
            const x = canvasSize.width * (horizontalProgress - 0.5);
            const waveAngle = horizontalProgress * Math.PI * 3;
            const y = canvasSize.height / 2 * Math.sin(waveAngle);
            ctx.beginPath();
            ctx.moveTo(center.x + x, center.y + y);
            ctx.lineTo(center.x + x, center.y - y);
            ctx.stroke();
        }
    }
    
    requestAnimationFrame(draw);
}

// Message handler for when the main thread sends the canvas
self.onmessage = function(event) {
    if (event.data.canvas) {
        canvas = event.data.canvas;
        ctx = canvas.getContext('2d');
        const canvasSize = { width: canvas.width, height: canvas.height };
        const center = { x: canvas.width / 2, y: canvas.height / 2 };
        initializeDots(canvasSize, center);
        requestAnimationFrame(draw);
    }
}; 