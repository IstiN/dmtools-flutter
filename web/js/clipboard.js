// Enhanced Clipboard API for Flutter Web
// This provides direct paste event handling for images and text (no permissions needed!)

window.ClipboardAPI = {
  // Check if paste events are supported (always true for modern browsers)
  isAvailable: function() {
    return true; // Paste events work in all modern browsers
  },

  // No permissions needed for paste events!
  requestPermissions: async function() {
    return true; // Paste events don't require permissions
  },

  // This method is now mainly for fallback text reading
  readClipboard: async function() {
    try {
      console.log('🔧 Trying fallback text clipboard read...');
      
      // Try simple text read (this might work for text)
      if (navigator.clipboard && navigator.clipboard.readText) {
        try {
          const text = await navigator.clipboard.readText();
          if (text && text.trim().length > 0) {
            console.log('✅ Fallback text found:', text.length, 'chars');
            return {
              type: 'text',
              content: text
            };
          }
        } catch (textError) {
          console.warn('⚠️ Text fallback failed:', textError);
        }
      }

      console.log('🔍 No content found via clipboard API');
      return null;

    } catch (error) {
      console.error('❌ Clipboard read failed:', error);
      return null;
    }
  },

  // Set up paste event listener for automatic handling (based on Stack Overflow solution)
  setupPasteListener: function(callback) {
    console.log('🔧 Setting up paste event listener...');
    
    const handlePaste = async (event) => {
      console.log('📋 Paste event detected');
      
      try {
        // Process clipboard data from paste event (this is the key!)
        if (event.clipboardData && event.clipboardData.items) {
          console.log('📋 Processing paste event data...', event.clipboardData.items.length, 'items');
          
          // Convert items to array for easier processing
          const items = Array.from(event.clipboardData.items);
          
          // Look for images first (priority)
          for (const item of items) {
            console.log('🔍 Checking item type:', item.type, 'kind:', item.kind);
            
            if (item.type.startsWith('image/') && item.kind === 'file') {
              console.log('🖼️ Image found in paste event:', item.type);
              
              // Prevent default paste behavior for images
              event.preventDefault();
              
              const file = item.getAsFile();
              if (file) {
                console.log('📁 File object created:', file.name, file.size, 'bytes');
                
                try {
                  const arrayBuffer = await file.arrayBuffer();
                  const uint8Array = new Uint8Array(arrayBuffer);
                  const bytes = Array.from(uint8Array);
                  
                  // Determine extension from MIME type
                  let extension = 'png';
                  if (item.type.includes('jpeg') || item.type.includes('jpg')) {
                    extension = 'jpg';
                  } else if (item.type.includes('gif')) {
                    extension = 'gif';
                  } else if (item.type.includes('webp')) {
                    extension = 'webp';
                  } else if (item.type.includes('bmp')) {
                    extension = 'bmp';
                  } else if (item.type.includes('svg')) {
                    extension = 'svg';
                  }
                  
                  const filename = `pasted_image_${Date.now()}.${extension}`;
                  
                  console.log('✅ Image processed successfully:', filename, bytes.length, 'bytes');
                  
                  // Call the callback with image data
                  const imageData = {
                    type: 'image',
                    content: {
                      name: filename,
                      size: bytes.length,
                      extension: extension,
                      bytes: bytes,
                      mimeType: item.type
                    }
                  };
                  
                  // Try multiple callback approaches
                  if (callback) {
                    try {
                      callback(imageData);
                    } catch (callbackError) {
                      console.error('❌ Callback failed:', callbackError);
                    }
                  }
                  
                  // Also try global Flutter callback if available
                  if (window.flutterPasteCallback) {
                    try {
                      window.flutterPasteCallback(imageData);
                    } catch (globalError) {
                      console.error('❌ Global callback failed:', globalError);
                    }
                  }
                  
                  // Store in global variable as fallback
                  window.lastPastedContent = imageData;
                  console.log('💾 Stored image data in window.lastPastedContent');
                  
                  return; // Exit after processing first image
                } catch (processingError) {
                  console.error('❌ Failed to process image:', processingError);
                }
              }
            }
          }
          
          // Look for text if no images found
          for (const item of items) {
            if (item.type.startsWith('text/') && item.kind === 'string') {
              console.log('📝 Text found in paste event:', item.type);
              
              // Don't prevent default for text - let it paste normally
              item.getAsString((text) => {
                if (text && text.trim().length > 0) {
                  console.log('✅ Text processed:', text.length, 'chars');
                  
                  const textData = {
                    type: 'text',
                    content: text
                  };
                  
                  // Try multiple callback approaches
                  if (callback) {
                    try {
                      callback(textData);
                    } catch (callbackError) {
                      console.error('❌ Text callback failed:', callbackError);
                    }
                  }
                  
                  // Also try global Flutter callback if available
                  if (window.flutterPasteCallback) {
                    try {
                      window.flutterPasteCallback(textData);
                    } catch (globalError) {
                      console.error('❌ Global text callback failed:', globalError);
                    }
                  }
                  
                  // Store in global variable as fallback
                  window.lastPastedContent = textData;
                  console.log('💾 Stored text data in window.lastPastedContent');
                }
              });
              
              return; // Exit after processing first text
            }
          }
          
          console.log('🔍 No supported content found in paste event');
        } else {
          console.log('⚠️ No clipboardData available in paste event');
        }
        
      } catch (error) {
        console.error('❌ Paste event handling failed:', error);
      }
    };
    
    // Add event listener to document (this captures all paste events)
    document.addEventListener('paste', handlePaste, true); // Use capture phase
    
    console.log('✅ Paste event listener set up successfully (Stack Overflow method)');
    
    // Return cleanup function
    return () => {
      document.removeEventListener('paste', handlePaste, true);
      console.log('🧹 Paste event listener cleaned up');
    };
  }
};

console.log('✅ Clipboard API initialized');
