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

### 🚀 Automatic Cache Busting

**SOLVED**: Safari aggressive caching issues are now automatically handled during deployment!

#### What Happens Automatically:
1. **Version Generation**: Each deployment gets a unique version (`YYYYMMDDHHMMSS-{git-hash}`)
2. **Resource Versioning**: All JS/CSS files get versioned query parameters
3. **Service Worker**: Automatically manages cache invalidation
4. **Cache Headers**: Proper cache control headers prevent aggressive caching

#### Deployment Process:
1. Code is pushed to `main` branch
2. GitHub Actions automatically runs cache busting script
3. Builds Flutter apps with versioned resources
4. Deploys to GitHub Pages with cache busting active
5. Creates `VERSION.txt` file with deployment info
6. Resets development files to preserve local workflow

#### Benefits:
✅ Safari cache issues resolved automatically  
✅ No manual intervention required  
✅ Preserves development workflow  
✅ Users always see latest version immediately  
✅ Works in both incognito and regular browser modes  

#### Verification:
- Check `https://ai-native.agency/VERSION.txt` for current deployment version
- Service workers automatically force updates
- No manual cache clearing required for users 