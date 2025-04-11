# VideoSensi

A Bash-based video compressor for Termux by @JubairZ.

## Installation
1. Clone the repo:
   ```bash
   pkg install git
   rm -f /data/data/com.termux/files/usr/bin/videosensi
   rm -rf VideoSensi
   git clone https://github.com/jubairbro/VideoSensi
   cd VideoSensi
   ```
2. Run setup:
   ```bash
   bash setup.sh
   ```
3. Grant storage permission:
   ```bash
   termux-setup-storage
   ```

## Usage
Run `videosensi` to start:
- **Compress Video**: Choose file, quality (Low, Medium, High, Ultra, Custom), watermark, and format (MP4, MKV, AVI).
- **Batch Compression**: Enter multiple files.
- **Preview**: Make a 10-second clip.
- **Settings**: Adjust theme (Dark, Light, Neon) or notifications.

**Outputs**: `/sdcard/VideoSensi/`  
**Logs**: `/sdcard/VideoSensi/logs/`  
**Backups**: `/sdcard/VideoSensi/backups/`

## Commands
- `videosensi`: Start tool.
- `videosensi --help`: Show help.
- `videosensi --tutorial`: Run tutorial.

## Features
- Colorful UI with animated logo and themes.
- Compression with 5 quality modes.
- Batch processing for multiple files.
- Auto-installs FFmpeg with backup methods.
- Validates video files.
- Shows metadata (codec, resolution, FPS).
- Custom watermark (text, position, color).
- Real-time progress bar.
- Preview clips.
- Backups original files.
- Termux toast notifications.
- Logs all actions.
- Auto-update checker.
- Tutorial for beginners.
- Safe Ctrl+C exit.

## Configuration
Edit `~/.videosensi.conf`:
```bash
THEME="Neon"
NOTIFY="y"
WATERMARK_TEXT="@JubairZ"
WATERMARK_POS="top-left"
WATERMARK_COLOR="white"
```

## Terms and Conditions
- Do not modify or redistribute without permission.
- Ensure compliance with FFmpeg's licensing terms.
- Back up important files before compression.

## Contact
- GitHub: https://github.com/jubairbro/
- Telegram: https://t.me/jubairFF/
- Contact: @JubairZ

## Copyright
© 2025 @JubairZ. All rights reserved.
```

---
