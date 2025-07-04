# Deployment Configuration

## Custom Domain Setup

This repository is configured to deploy to the custom domain: **ai-native.agency**

### DNS Configuration
The domain is configured with the following DNS settings in GoDaddy:

**A Records:**
- `@` → `185.199.108.153`
- `@` → `185.199.109.153`
- `@` → `185.199.110.153`
- `@` → `185.199.111.153`

**AAAA Records (IPv6):**
- `@` → `2606:50c0:8000::153`
- `@` → `2606:50c0:8001::153`
- `@` → `2606:50c0:8002::153`
- `@` → `2606:50c0:8003::153`

**CNAME Record:**
- `www` → `[username].github.io`

### GitHub Pages Configuration
- **Custom domain:** `ai-native.agency`
- **HTTPS:** Enforced (automatically provided by GitHub)
- **Source:** GitHub Actions workflow

### URLs
- **Main Application:** https://ai-native.agency/
- **Styleguide:** https://ai-native.agency/styleguide/
- **Navigation:** https://ai-native.agency/navigation.html

### Files
- `CNAME` - Contains the custom domain name
- `.github/workflows/deploy-pages.yml` - Deployment workflow configured for custom domain

### Build Configuration
The Flutter web builds use the following base-href configurations:
- Main app: `--base-href=/`
- Styleguide: `--base-href=/styleguide/`

This ensures proper routing for the custom domain setup. 