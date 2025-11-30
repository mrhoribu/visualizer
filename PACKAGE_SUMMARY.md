# 🎉 Visualizer GitHub Integration - Complete Package

## What You've Got

This package includes everything you need to set up automatic GitHub-based asset management for your Visualizer script.

## 📦 Package Contents

### Main Files
✅ **visualizer.rb** - Refactored script with GitHub integration  
✅ **generate_manifest.rb** - Manifest generator  
✅ **manifest.yaml** - Sample manifest format  

### GitHub Workflows (3 Options)
✅ **simple-manifest-update.yml** - Recommended starter workflow  
✅ **update-manifest.yml** - Enhanced with better commit messages  
✅ **update-manifest-enhanced.yml** - Full validation & reporting  

### Documentation
✅ **README.md** - Complete script documentation  
✅ **GITHUB_SETUP.md** - Step-by-step setup guide  
✅ **QUICK_REFERENCE.md** - Quick commands & tips  
✅ **.github/workflows/README.md** - Workflow documentation  

## 🚀 Quick Start (Choose Your Path)

### Path 1: Just Want It Working (5 min)
1. Create GitHub repo: `gh repo create visualizer-assets --public`
2. Add `.github/workflows/simple-manifest-update.yml`
3. Add `generate_manifest.rb` to root
4. Put images in `images/` folder
5. Run `ruby generate_manifest.rb images manifest.yaml`
6. Commit and push
7. Update `visualizer.rb` with your repo URL

### Path 2: Want Full Features (10 min)
- Follow GITHUB_SETUP.md completely
- Use `update-manifest-enhanced.yml` workflow
- Set up branch protection
- Enable PR validation

### Path 3: Manual Setup Only
- Skip GitHub workflows
- Use `generate_manifest.rb` manually
- Commit manifest yourself
- Still get checksum validation

## 🎯 What Each File Does

### visualizer.rb
- Displays room images in GTK window
- Auto-downloads images from GitHub
- Validates checksums
- Caches manifest for 24 hours
- YAML configuration

### generate_manifest.rb
- Scans directory for PNG files
- Calculates SHA256 checksums
- Generates manifest.yaml
- Shows file statistics

### Workflows
**simple-manifest-update.yml**
- Runs when images pushed to main
- Regenerates manifest automatically
- Commits back to repo

**update-manifest.yml**
- Same as simple + detailed commit messages
- Lists which images changed

**update-manifest-enhanced.yml**
- Everything above +
- Validates image files
- Warns about large files
- Comments on PRs
- Creates job summaries

## 🔧 Configuration Quick Reference

### In visualizer.rb (Update These!)
```ruby
GITHUB_REPO = 'your-username/visualizer-assets'  # ← YOUR REPO
GITHUB_BRANCH = 'main'
```

### In visualizer_config.yaml (Auto-created)
```yaml
auto_update_assets: true  # Set false to disable
```

## 📂 Where Files Go

### GitHub Repository
```
visualizer-assets/
├── .github/workflows/simple-manifest-update.yml
├── images/*.png
├── generate_manifest.rb
├── manifest.yaml
└── README.md
```

### Lich Scripts Directory
```
<SCRIPT_DIR>/visualizer.rb
```

### Data Directory (Auto-created)
```
<DATA_DIR>/<game>/<character>/visualizer_config.yaml
```

## ✨ Key Features

### Automatic Updates
- Script checks GitHub every 24 hours
- Downloads new/changed images
- Validates with checksums
- Manual update: `;visualizer update`

### Smart Caching
- Manifest cached 24 hours
- Only downloads when needed
- Validates before accepting

### Checksum Validation
- SHA256 for each file
- Detects corrupted downloads
- Ensures file integrity

### GitHub Workflows
- Auto-updates manifest
- Validates images
- Comments on PRs
- Prevents infinite loops

## 🎮 Using the Script

### Start Visualizer
```
;visualizer
```

### Force Update Assets
```
;visualizer update
```

### Show Help
```
;visualizer help
```

### Add to Autostart
```
;autostart add visualizer
```

## 🔨 Managing Your Assets

### Add New Image
```bash
cp new.png images/u12345.png
git add images/u12345.png
git commit -m "Add room 12345"
git push  # Manifest updates automatically!
```

### Update Existing Image
```bash
cp updated.png images/u12345.png
git add images/u12345.png
git commit -m "Update room 12345 with better quality"
git push  # Checksum updates automatically!
```

### Manually Regenerate Manifest
```bash
ruby generate_manifest.rb images manifest.yaml
```

## 🎨 Image Naming Convention

- **Room UIDs**: `u12345.png`
- **Locations**: `Wehnimer's Landing.png`
- **Fallback**: `null.png` (required)

The script tries in this order:
1. Room UID (u12345.png)
2. Location name (Wehnimer's Landing.png)
3. Fallback (null.png)

## 📊 What Gets Tracked

In manifest.yaml:
```yaml
u12345.png:
  checksum: abc123...  # SHA256 hash
  size: 245678        # File size in bytes
  description: "Room UID 12345 image"
```

## 🚦 Testing Your Setup

### 1. Test Locally
```bash
ruby generate_manifest.rb images manifest.yaml
ruby -c visualizer.rb
```

### 2. Test GitHub Workflow
- Push a test image
- Watch Actions tab
- Verify manifest updated

### 3. Test Script
```bash
;visualizer update
# Check for download messages
```

## 🐛 Common Issues & Fixes

| Problem | Fix |
|---------|-----|
| Workflow not running | Check file is in `.github/workflows/` |
| Can't push manifest | Add `contents: write` permission |
| Infinite loop | Add `[skip ci]` to commits |
| Checksum fails | Regenerate manifest locally |
| Images not downloading | Check repo URL in script |
| Script not starting | Check Visualizer folder exists |

## 📈 Workflow Selection Guide

**Use simple-manifest-update.yml if:**
- You're just getting started
- You want set-it-and-forget-it
- You don't need validation

**Use update-manifest.yml if:**
- You want better commit tracking
- You want to see what changed
- You're managing many images

**Use update-manifest-enhanced.yml if:**
- You have multiple contributors
- You want PR validation
- You need image size warnings
- You want detailed reports

## 🎓 Learning Path

1. **Day 1**: Set up basic repo with simple workflow
2. **Week 1**: Add more images, see auto-updates work
3. **Month 1**: Upgrade to enhanced workflow
4. **Month 2**: Set up branch protection, PR reviews

## 🔗 Important Links to Update

After setup, share these with users:

```
Repository: https://github.com/YOUR-USERNAME/visualizer-assets
Raw Images: https://raw.githubusercontent.com/YOUR-USERNAME/visualizer-assets/main/images/
Manifest: https://raw.githubusercontent.com/YOUR-USERNAME/visualizer-assets/main/manifest.yaml
```

## 💡 Pro Tips

1. **Optimize images before upload**: Use pngquant
2. **Use descriptive commit messages**: Helps tracking
3. **Test locally first**: Run generate_manifest.rb
4. **Monitor Actions tab**: Catch issues early
5. **Keep null.png updated**: It's the fallback

## 📝 Checklist for Go-Live

- [ ] GitHub repository created
- [ ] Workflow file added
- [ ] generate_manifest.rb in repo
- [ ] Initial images uploaded
- [ ] Initial manifest generated
- [ ] visualizer.rb updated with repo URL
- [ ] Workflow tested successfully
- [ ] Script tested with `;visualizer update`
- [ ] README.md updated with your info
- [ ] Shared with community!

## 🎊 What's New vs Original Script

### Architecture
✅ Proper namespace (Visualizer module)
✅ Class-based design
✅ Separated concerns
✅ Better error handling

### Configuration
✅ YAML config file
✅ Per-character settings
✅ Auto-update toggle

### Asset Management
✅ GitHub integration
✅ Checksum validation
✅ Automatic downloads
✅ Smart caching

### Automation
✅ GitHub Actions workflows
✅ Auto-manifest generation
✅ PR validation
✅ Detailed reporting

## 📚 Documentation Map

- **Getting Started**: GITHUB_SETUP.md → Start here!
- **Quick Commands**: QUICK_REFERENCE.md → Bookmark this
- **Full Details**: README.md → Reference material
- **Workflows**: .github/workflows/README.md → For GitHub setup
- **This File**: Big picture overview

## 🤝 Contributing

Want to improve this? Contributions welcome:
- Report issues
- Submit PRs for new features
- Share your workflows
- Help with documentation

## 🙏 Credits

- **Original Author**: Selfane
- **Contributors**: Tysong
- **Art**: Alosaka, Oro
- **Refactor**: 2024 modernization

## 📄 License

[Add your license here]

---

## Ready to Deploy?

1. Read GITHUB_SETUP.md
2. Create your repository
3. Update visualizer.rb constants
4. Test locally
5. Deploy!

**Questions?** Check the documentation or open an issue.

**Everything Working?** Share with the community!

---

Made with ❤️ for the Gemstone IV community
