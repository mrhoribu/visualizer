# GitHub Repository Setup Guide

This guide walks you through setting up a GitHub repository to host your Visualizer assets with automatic manifest updates.

## Quick Start

### Option 1: Create New Repository on GitHub.com

1. Go to https://github.com/new
2. Repository name: `visualizer-assets` (or your choice)
3. Description: "Image assets for Gemstone IV Visualizer"
4. Choose Public or Private
5. ✅ Add README file
6. Click "Create repository"

### Option 2: Create from Command Line

```bash
# Create local directory
mkdir visualizer-assets
cd visualizer-assets

# Initialize git
git init
git branch -M main

# Create initial structure
mkdir images
mkdir .github/workflows

# Create README
echo "# Visualizer Assets" > README.md
echo "Image assets for Gemstone IV Visualizer script" >> README.md

# Initial commit
git add .
git commit -m "Initial commit"

# Create GitHub repo (requires GitHub CLI)
gh repo create visualizer-assets --public --source=. --push
```

## Complete Setup Process

### Step 1: Prepare Your Files

Gather these files:
- ✅ `generate_manifest.rb` - Manifest generator script
- ✅ `images/` directory with PNG files
- ✅ `.github/workflows/simple-manifest-update.yml` - GitHub workflow
- ✅ `README.md` - Documentation

### Step 2: Set Up Directory Structure

```bash
visualizer-assets/
├── .github/
│   └── workflows/
│       └── simple-manifest-update.yml
├── images/
│   ├── u1.png
│   ├── u2.png
│   ├── null.png
│   └── ...
├── generate_manifest.rb
├── manifest.yaml (will be auto-generated)
└── README.md
```

### Step 3: Add Files to Repository

```bash
cd visualizer-assets

# Copy workflow file
mkdir -p .github/workflows
cp /path/to/simple-manifest-update.yml .github/workflows/

# Copy generator script
cp /path/to/generate_manifest.rb .

# Copy images
cp /path/to/images/*.png images/

# Add all files
git add .
git commit -m "Initial setup with images and workflow"
git push origin main
```

### Step 4: Generate Initial Manifest

```bash
# Generate manifest locally first
ruby generate_manifest.rb images manifest.yaml

# Review the manifest
cat manifest.yaml

# Commit it
git add manifest.yaml
git commit -m "Add initial manifest"
git push
```

### Step 5: Verify Workflow

1. Go to your repository on GitHub
2. Click "Actions" tab
3. Verify "Auto-Update Manifest" workflow appears
4. Click on it to see status

### Step 6: Test Automatic Updates

```bash
# Add a test image
cp test_image.png images/u99999.png

# Commit and push
git add images/u99999.png
git commit -m "Test: add room 99999"
git push

# Watch GitHub Actions
# Go to Actions tab → should see workflow running
# When complete, manifest.yaml should be updated
```

## Update Visualizer Script

After setting up the repository, update your `visualizer.rb`:

```ruby
module Visualizer
  # GitHub repository configuration
  GITHUB_REPO = 'your-username/visualizer-assets'  # ← Change this
  GITHUB_BRANCH = 'main'
  MANIFEST_URL = "https://raw.githubusercontent.com/#{GITHUB_REPO}/#{GITHUB_BRANCH}/manifest.yaml"
end
```

## Configuration Options

### Using a Private Repository

If your repository is private, users will need authentication. Options:

1. **Personal Access Token (PAT)**
   - Create PAT at: https://github.com/settings/tokens
   - Users must set: `export GITHUB_TOKEN=ghp_xxxxx`
   - Update script to use token in requests

2. **Make Repository Public**
   - Simplest option for community sharing
   - No authentication needed

### Using Different Branch

To use a branch other than `main`:

```ruby
GITHUB_BRANCH = 'assets'  # or 'images', etc.
```

Update workflow to match:
```yaml
on:
  push:
    branches:
      - assets  # Change from main
```

### Multiple Asset Sources

For fallback or multiple sources:

```ruby
GITHUB_REPOS = [
  'primary-user/visualizer-assets',
  'backup-user/visualizer-assets'
]
```

## Best Practices

### Repository Organization

```
visualizer-assets/
├── .github/
│   └── workflows/
│       ├── simple-manifest-update.yml  # Main workflow
│       └── validate-images.yml         # Optional validation
├── images/
│   ├── rooms/           # Optional: organize by type
│   │   ├── u1.png
│   │   └── u2.png
│   ├── locations/
│   │   └── Wehnimer's Landing.png
│   └── null.png
├── docs/
│   ├── CONTRIBUTING.md  # How to add images
│   └── IMAGE_GUIDELINES.md
├── scripts/
│   └── generate_manifest.rb
├── manifest.yaml
└── README.md
```

### Git Configuration

Add `.gitattributes` for better handling:
```
# .gitattributes
*.png filter=lfs diff=lfs merge=lfs -text
manifest.yaml merge=ours
```

### Image Organization

Choose a structure:

**Option 1: Flat Structure (Recommended)**
```
images/
├── u1.png
├── u2.png
└── location.png
```

**Option 2: Organized Structure**
```
images/
├── rooms/
│   └── u*.png
└── locations/
    └── *.png
```

If using Option 2, update paths in scripts and workflow.

## Troubleshooting

### Workflow Not Running

**Check workflow file location:**
```bash
ls -la .github/workflows/
# Should show: simple-manifest-update.yml
```

**Verify Actions are enabled:**
1. Go to repository Settings
2. Click "Actions" → "General"
3. Ensure "Allow all actions and reusable workflows" is selected

### Push Rejected

**Problem**: `error: failed to push some refs`

**Solution**: Pull first, then push:
```bash
git pull --rebase origin main
git push origin main
```

### Workflow Permissions Error

**Problem**: "Resource not accessible by integration"

**Solution**: Update workflow permissions:
```yaml
permissions:
  contents: write  # Make sure this is present
```

Or in repository settings:
1. Settings → Actions → General
2. "Workflow permissions"
3. Select "Read and write permissions"

### Large Repository Size

**Problem**: Repository becomes too large with many images

**Solutions:**

1. **Use Git LFS** (Large File Storage):
```bash
git lfs install
git lfs track "*.png"
git add .gitattributes
```

2. **Optimize Images**:
```bash
# Use pngquant or similar
for img in images/*.png; do
  pngquant --quality=65-80 --ext .png --force "$img"
done
```

3. **Split into Multiple Repos**:
```
visualizer-assets-1/  # Rooms 1-5000
visualizer-assets-2/  # Rooms 5001-10000
```

## Advanced Setup

### Adding Image Validation

Create `.github/workflows/validate-images.yml`:

```yaml
name: Validate Images

on:
  pull_request:
    paths:
      - 'images/**/*.png'

jobs:
  validate:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - name: Check image sizes
        run: |
          for img in images/*.png; do
            size=$(stat -c%s "$img")
            if [ $size -gt 5242880 ]; then
              echo "❌ $img is too large: $((size/1024/1024))MB"
              exit 1
            fi
          done
```

### Adding Release Workflow

Create `.github/workflows/create-release.yml`:

```yaml
name: Create Release

on:
  push:
    tags:
      - 'v*'

jobs:
  release:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - name: Create Release
        uses: softprops/action-gh-release@v1
        with:
          files: |
            manifest.yaml
            generate_manifest.rb
          generate_release_notes: true
```

### Branch Protection

For production repositories:

1. Go to Settings → Branches
2. Add rule for `main` branch
3. Enable:
   - ✅ Require pull request reviews
   - ✅ Require status checks (workflows) to pass
   - ✅ Require conversation resolution

## Maintenance

### Regular Tasks

**Weekly:**
- Check for failed workflow runs
- Review any PR comments from validation

**Monthly:**
- Review repository size
- Optimize images if needed
- Update documentation

**Quarterly:**
- Update Ruby version in workflow
- Review and update dependencies
- Archive old/unused images

### Updating Scripts

When updating `generate_manifest.rb`:

```bash
# Update the script
git add generate_manifest.rb
git commit -m "Update manifest generator with new feature"
git push

# Manually trigger workflow to regenerate manifest
# GitHub → Actions → Auto-Update Manifest → Run workflow
```

## Examples

### Example 1: Adding 100 Room Images

```bash
# Bulk add images
cp ~/room_images/*.png images/

# Check what was added
git status

# Commit with good message
git add images/
git commit -m "Add 100 room images for Ta'Vaalor
  
  Images cover rooms u10000-u10099 in the Ta'Vaalor
  area including the castle and surrounding streets."

git push

# Workflow automatically updates manifest
```

### Example 2: Updating Image Quality

```bash
# Optimize all images
for img in images/*.png; do
  pngquant --quality=70-85 "$img" --ext .png --force
done

# Commit updates
git add images/
git commit -m "Optimize all images for better quality/size ratio"
git push

# Manifest checksums automatically update
```

### Example 3: Collaborative Workflow

```bash
# Contributor forks repository
# Adds images to their fork
# Creates pull request

# Repository owner:
# 1. Reviews PR
# 2. Checks workflow validation results
# 3. Merges PR
# 4. Manifest auto-updates on merge
```

## Resources

- **GitHub Actions Docs**: https://docs.github.com/en/actions
- **GitHub CLI**: https://cli.github.com/
- **Git LFS**: https://git-lfs.github.com/
- **Image Optimization**: https://imageoptim.com/

## Next Steps

After setup:

1. ✅ Test adding an image and verify workflow runs
2. ✅ Update `visualizer.rb` with your repo URL
3. ✅ Share repository URL with users
4. ✅ Set up branch protection (optional)
5. ✅ Add CONTRIBUTING.md for collaborators

Need help? Check the main README.md or open an issue in your repository!
