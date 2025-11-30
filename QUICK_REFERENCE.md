# Visualizer GitHub Integration - Quick Reference

## 📦 Files Overview

### Core Script Files
- **visualizer.rb** - Main Lich5 script with GitHub integration
- **generate_manifest.rb** - Script to generate manifest.yaml from images
- **manifest.yaml** - Sample manifest showing expected format

### GitHub Workflows (Choose One)
Located in `.github/workflows/`:

1. **simple-manifest-update.yml** ⭐ **RECOMMENDED**
   - Simple and reliable
   - Auto-updates manifest on image changes
   - Best for most users

2. **update-manifest.yml**
   - Enhanced commit messages
   - Lists changed images
   - Good for tracking

3. **update-manifest-enhanced.yml**
   - Full validation and reporting
   - PR comments with results
   - Image size warnings
   - Best for production

### Documentation
- **README.md** - Complete script documentation
- **GITHUB_SETUP.md** - Step-by-step repository setup guide
- **.github/workflows/README.md** - Workflow documentation

## 🚀 Quick Setup (5 Minutes)

### 1. Create GitHub Repository
```bash
gh repo create visualizer-assets --public
```

### 2. Set Up Structure
```bash
cd visualizer-assets
mkdir -p images .github/workflows
```

### 3. Add Files
```bash
# Copy workflow (choose one)
cp simple-manifest-update.yml .github/workflows/

# Copy generator
cp generate_manifest.rb .

# Add your images
cp /path/to/images/*.png images/
```

### 4. Generate Initial Manifest
```bash
ruby generate_manifest.rb images manifest.yaml
```

### 5. Commit and Push
```bash
git add .
git commit -m "Initial setup"
git push origin main
```

### 6. Update Script
Edit `visualizer.rb`:
```ruby
GITHUB_REPO = 'your-username/visualizer-assets'
```

## 📋 Common Commands

### Add New Images
```bash
cp new_image.png images/
git add images/
git commit -m "Add new room image"
git push  # Manifest updates automatically
```

### Force Manifest Regeneration
```bash
ruby generate_manifest.rb images manifest.yaml
git add manifest.yaml
git commit -m "Regenerate manifest"
git push
```

### Manual Workflow Trigger
1. Go to GitHub → Actions tab
2. Select workflow
3. Click "Run workflow"

### Update Visualizer Script
```bash
;visualizer update  # Force asset check and download
```

## 🎯 File Placement Guide

### In Your GitHub Repository
```
visualizer-assets/
├── .github/
│   └── workflows/
│       └── simple-manifest-update.yml
├── images/
│   ├── u1.png
│   ├── u2.png
│   └── null.png
├── generate_manifest.rb
├── manifest.yaml
└── README.md
```

### In Your Lich Scripts Directory
```
<SCRIPT_DIR>/
├── visualizer.rb
└── Visualizer/  (created automatically)
    ├── manifest.yaml  (downloaded from GitHub)
    ├── u1.png        (downloaded from GitHub)
    └── ...
```

### In Your Data Directory
```
<DATA_DIR>/<game>/<character>/
└── visualizer_config.yaml  (created automatically)
```

## 🔧 Configuration Reference

### visualizer_config.yaml
```yaml
window_position: [500, 500]
window_width: 500
window_height: 500
auto_update_assets: true
last_asset_check: 2024-01-15 10:30:00 UTC
```

### Script Constants (in visualizer.rb)
```ruby
GITHUB_REPO = 'your-username/visualizer-assets'
GITHUB_BRANCH = 'main'
MANIFEST_CACHE_HOURS = 24
ASSET_CHECK_INTERVAL_HOURS = 24
```

## 🎨 Workflow Features Comparison

| Feature | Simple | Basic | Enhanced |
|---------|--------|-------|----------|
| Auto-update manifest | ✅ | ✅ | ✅ |
| Skip infinite loops | ✅ | ✅ | ✅ |
| Detailed commits | ❌ | ✅ | ✅ |
| Image validation | ❌ | ❌ | ✅ |
| Size warnings | ❌ | ❌ | ✅ |
| PR comments | ❌ | ❌ | ✅ |
| Statistics | ❌ | ❌ | ✅ |
| Artifacts | ❌ | ❌ | ✅ |

## 💡 Tips & Tricks

### Optimize Images Before Upload
```bash
pngquant --quality=70-85 *.png --ext .png --force
```

### Bulk Rename for Room UIDs
```bash
for f in room_*.png; do
  uid=$(echo $f | grep -o '[0-9]*')
  mv "$f" "u${uid}.png"
done
```

### Check Manifest Validity
```bash
ruby -r yaml -e "YAML.load_file('manifest.yaml')"
```

### List Images by Size
```bash
ls -lhS images/*.png | head -10
```

### Count Images by Type
```bash
echo "Room UIDs: $(ls images/u*.png 2>/dev/null | wc -l)"
echo "Locations: $(ls images/*.png 2>/dev/null | grep -v '^u' | wc -l)"
```

## 🐛 Quick Troubleshooting

| Issue | Solution |
|-------|----------|
| Workflow not running | Check `.github/workflows/` path is correct |
| Permission denied | Add `contents: write` to workflow |
| Infinite loop | Use `[skip ci]` in commit message |
| Large file error | Optimize images or use Git LFS |
| Script not found | Ensure `generate_manifest.rb` in repo root |
| Checksum mismatch | Regenerate manifest locally and push |

## 📚 Documentation Map

Need more info? Check these docs:

- **Getting Started**: GITHUB_SETUP.md
- **Script Usage**: README.md
- **Workflow Details**: .github/workflows/README.md
- **This File**: Quick reference

## 🎮 Lich Script Commands

```
;visualizer              # Start visualizer
;visualizer update       # Force asset update
;visualizer help         # Show help
;autostart add visualizer # Add to autostart
```

## 🔗 Important URLs

### Your Repository (Update These)
```
Repository: https://github.com/your-username/visualizer-assets
Manifest: https://raw.githubusercontent.com/your-username/visualizer-assets/main/manifest.yaml
Images: https://raw.githubusercontent.com/your-username/visualizer-assets/main/images/
```

### Tools & Resources
- GitHub CLI: https://cli.github.com/
- Image Optimization: https://imageoptim.com/
- Git LFS: https://git-lfs.github.com/

## ⚡ One-Line Setups

### Complete Local Setup
```bash
mkdir visualizer-assets && cd visualizer-assets && mkdir -p images .github/workflows && git init && git branch -M main
```

### Quick Commit All
```bash
git add . && git commit -m "Update images and manifest" && git push
```

### Regenerate and Push
```bash
ruby generate_manifest.rb images manifest.yaml && git add manifest.yaml && git commit -m "Update manifest" && git push
```

## 🎯 Next Steps

1. ✅ Set up GitHub repository
2. ✅ Add workflow file
3. ✅ Upload images
4. ✅ Update visualizer.rb with your repo URL
5. ✅ Test with `;visualizer update`
6. ✅ Share with community!

---

**Need Help?** Open an issue on GitHub or check the full documentation files.
