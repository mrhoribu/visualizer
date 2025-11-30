# Visualizer for Gemstone IV

A Lich5 script that displays room images in a GTK window as you move through Gemstone IV, with automatic asset management from GitHub.

## Features

- 🖼️ **Automatic Image Display**: Shows images for rooms based on UID or location name
- 🔄 **Auto-Update Assets**: Automatically downloads and updates images from GitHub
- ✅ **Checksum Validation**: Ensures image integrity with SHA256 checksums
- 💾 **YAML Configuration**: Persistent settings stored in YAML format
- 🪟 **Resizable Window**: Window size and position are remembered between sessions
- 🎨 **Clean Architecture**: Modern Ruby design with proper namespacing

## Installation

### 1. Install the Script

Place `visualizer.rb` in your Lich scripts directory.

### 2. Add to Autostart (Optional)

```
;autostart add visualizer
```

Or globally:

```
;autostart add --global visualizer
```

## Usage

### Basic Usage

Start the visualizer:
```
;visualizer
```

### Force Asset Update

Manually check for and download new/updated assets:
```
;visualizer update
```

### View Help

```
;visualizer help
```

## Configuration

Configuration is stored in a YAML file at:
```
<DATA_DIR>/<game>/<character>/visualizer_config.yaml
```

### Configuration Options

```yaml
window_position: [500, 500]     # X, Y coordinates
window_width: 500               # Window width in pixels
window_height: 500              # Window height in pixels
auto_update_assets: true        # Automatically check for updates
last_asset_check: 2024-01-15... # Last time assets were checked
```

### Disabling Auto-Updates

Edit your config file and set:
```yaml
auto_update_assets: false
```

## GitHub Repository Setup

### Repository Structure

Your GitHub repository should have this structure:

```
your-repo/
├── manifest.yaml
└── images/
    ├── u1.png
    ├── u2.png
    ├── u123.png
    ├── Wehnimer's Landing.png
    ├── null.png
    └── ...
```

### Updating the Repository URL

In `visualizer.rb`, update these constants:

```ruby
GITHUB_REPO = 'your-username/visualizer-assets'
GITHUB_BRANCH = 'main'
```

### Generating the Manifest

Use the included `generate_manifest.rb` script:

```bash
ruby generate_manifest.rb ./images manifest.yaml
```

This will:
1. Scan all PNG files in the images directory
2. Calculate SHA256 checksums for each file
3. Generate a `manifest.yaml` file

### Manifest Format

The `manifest.yaml` file should look like:

```yaml
u1.png:
  checksum: 5d41402abc4b2a76b9719d911017c592...
  size: 245678
  description: "Room UID 1 image"

"Wehnimer's Landing.png":
  checksum: 3f5a8b9c1d2e4f5a6b7c8d9e0f1a2b3c...
  size: 312456
  description: "Location image: Wehnimer's Landing"

null.png:
  checksum: 1a2b3c4d5e6f7a8b9c0d1e2f3a4b5c6d...
  size: 15234
  description: "Fallback image when room image not found"
```

## How It Works

### Image Selection Priority

1. **Room UID**: Looks for `u<room_uid>.png` (e.g., `u12345.png`)
2. **Location Name**: Looks for `<location>.png` (e.g., `Wehnimer's Landing.png`)
3. **Fallback**: Uses `null.png` if neither exists

### Asset Update Process

1. Script checks if 24 hours have passed since last check
2. Downloads `manifest.yaml` from GitHub
3. Compares local files against manifest checksums
4. Downloads missing or outdated images
5. Validates checksums after download

### Update Frequency

- **Automatic**: Every 24 hours (when script starts)
- **Manual**: Run `;visualizer update` anytime
- **Manifest Cache**: 24 hours

## File Locations

### Script Location
```
<SCRIPT_DIR>/visualizer.rb
```

### Assets Directory
```
<SCRIPT_DIR>/Visualizer/
```

### Configuration File
```
<DATA_DIR>/<game>/<character>/visualizer_config.yaml
```

## Troubleshooting

### Images Not Displaying

1. Check if the Visualizer directory exists
2. Run `;visualizer update` to download assets
3. Check network connectivity
4. Verify GitHub repository URL is correct

### Checksum Mismatches

If checksums don't match after download:
1. The file may be corrupted
2. The manifest may be out of sync
3. Try regenerating the manifest with `generate_manifest.rb`

### Manual Asset Installation

If you prefer to install assets manually:

1. Download from the Google Drive link (shown on first run)
2. Extract to `<SCRIPT_DIR>/Visualizer/`
3. Set `auto_update_assets: false` in config

## Architecture

The script is organized into several classes:

- **ChecksumValidator**: Calculates and validates SHA256 checksums
- **AssetManager**: Handles manifest and asset downloads from GitHub
- **Config**: Manages YAML configuration loading/saving
- **ImageManager**: Resolves image paths and validates existence
- **WindowManager**: Handles GTK window and image display
- **Application**: Main controller orchestrating everything

## Contributing

### Adding New Images

1. Add PNG files to your GitHub repository's `images/` directory
2. Run `generate_manifest.rb` to update the manifest
3. Commit and push both the new images and updated manifest
4. Users will automatically get the new images on next check

### Image Naming Convention

- **Room UIDs**: `u<uid>.png` (e.g., `u12345.png`)
- **Locations**: `<location name>.png` (e.g., `Wehnimer's Landing.png`)
- **Fallback**: `null.png` (required)

## Credits

- **Author**: Selfane
- **Contributors**: Tysong
- **Art**: Alosaka, Oro
- **Version**: 0.10.0

## Version History

- **0.10.0**: Complete refactor with GitHub integration, YAML config, modern Ruby practices
- **0.09.2**: Rubocop cleanup, File.join usage, failsafe checks
- **0.09.1**: Proper art credit
- **0.09.0**: Initial script upload

## License

[Add your license here]

## Support

For issues, questions, or contributions, please [open an issue on GitHub] or contact the maintainers.
