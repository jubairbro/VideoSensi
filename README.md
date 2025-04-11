# VideoSensi

A flashy, feature-packed Bash-based video compressor for Termux, crafted by @JubairZ.

## Features
- **Stunning UI**: Animated logo, randomized colors, themed interfaces (Dark, Light, Neon).
- **Compression Modes**: Low, Medium, High, Ultra, plus custom CRF.
- **Batch Processing**: Compress multiple videos in one go.
- **Auto FFmpeg Install**: 4 backup methods with retry logic.
- **Video Validation**: Checks file, format, size, and duration.
- **Detailed Metadata**: Shows codec, resolution, FPS, bitrate, and more.
- **Custom Outputs**: MP4, MKV, AVI formats, saved to `/sdcard/VideoSensi/`.
- **Watermarking**: Custom text, position, and color.
- **Real-Time Progress**: Animated bar with FFmpeg progress parsing.
- **Preview Clips**: 10-second sample before compression.
- **Backups**: Original files saved to `/sdcard/VideoSensi/backups/`.
- **Notifications**: Termux toast alerts for success/failure.
- **Configuration**: Save preferences in `~/.videosensi.conf`.
- **Logs**: Detailed logs in `/sdcard/VideoSensi/logs/`.
- **Auto-Update**: Checks for new versions via GitHub.
- **Tutorial Mode**: Guided walkthrough for new users.
- **Safe Exit**: Ctrl+C cleanup with state saving.

## Installation
1. Clone the repository:
   ```bash
   git clone https://github.com/jubairbro/VideoSensi
   cd VideoSensi
   ```
2. Run the setup script:
   ```bash
   bash setup.sh
   ```
3. Start the tool:
   ```bash
   videosensi
   ```

## Usage
- Run `videosensi` to enter the interactive menu.
- Choose:
  - **Compress Video**: Single file compression.
  - **Batch Compression**: Multiple files.
  - **Generate Preview**: 10-second clip.
  - **Settings**: Customize theme, notifications, watermark.
- Outputs are saved to `/sdcard/VideoSensi/`.
- Logs are saved to `/sdcard/VideoSensi/logs/`.
- Backups are saved to `/sdcard/VideoSensi/backups/`.

## Commands
- `videosensi`: Start the tool.
- `videosensi --help`: Show help menu.
- `videosensi --tutorial`: Start interactive tutorial.

## Configuration
Edit `~/.videosensi.conf` to customize:
- `THEME`: Dark, Light, Neon
- `NOTIFY`: y/n
- `WATERMARK_TEXT`: Default watermark text
- `WATERMARK_POS`: top-left, top-right, bottom-left, bottom-right
- `WATERMARK_COLOR`: Watermark color

## Notes
- GitHub: https://github.com/jubairbro/
- Telegram: https://t.me/jubairFF/
- Contact: @JubairZ

## Requirements
- Termux
- Internet connection (for FFmpeg and updates)
- Storage access permission

## FAQ
- **Why does FFmpeg fail to install?**
  Ensure a stable internet connection and run `setup.sh` again.
- **Where are my files?**
  Outputs: `/sdcard/VideoSensi/`
  Logs: `/sdcard/VideoSensi/logs/`
  Backups: `/sdcard/VideoSensi/backups/`
```

---

#### 4. Placeholder `update.txt`

Hosted on GitHub (e.g., `https://raw.githubusercontent.com/jubairbro/VideoSensi/main/update.txt`).

```text
version=2.0.1
```

---

#### 5. Default Config: `config.conf`

Created by `setup.sh` if not present.

```bash
THEME="Neon"
NOTIFY="y"
WATERMARK_TEXT="@JubairZ"
WATERMARK_POS="top-left"
WATERMARK_COLOR="white"
```

---

### Key Enhancements
- **Line Count**: Over 700 lines with extensive comments and modularity (20+ functions).
- **Flashiness**: Animated logo, randomized colors, themed UI, Termux toast notifications.
- **New Features**:
  - **Batch Mode**: Compress multiple files with shared settings.
  - **Preview Clips**: Generate 10-second samples.
  - **Custom Formats**: MP4, MKV, AVI support.
  - **Notifications**: Success/failure alerts via `termux-toast`.
  - **Backups**: Original files saved before compression.
  - **Config File**: Persistent settings for theme, watermark, etc.
  - **Themes**: Dark, Light, Neon options.
  - **Tutorial**: Interactive guide for first-time users.
- **Progress Bar**: Parses FFmpeg output for real-time updates (simplified for stability).
- **Backup Methods**: Four FFmpeg install methods with detailed logging.
- **Watermark**: Fully customizable (text, position, color).
- **Error Handling**: Robust validation and logging for all steps.
- **Style**: Over-the-top with box-style comments, animations, and vibrant colors.

### How to Use
1. Clone the repository to Termux:
   ```bash
   git clone https://github.com/jubairbro/VideoSensi
   cd VideoSensi
   ```
2. Run `setup.sh`:
   ```bash
   bash setup.sh
   ```
3. Start the tool:
   ```bash
   videosensi
   ```
4. Follow the menu to compress videos, generate previews, or tweak settings.


This tool is maintained and built by the user for personal and community use.  
Made with **Bash** & **FFmpeg** in **Termux**.

---

## Enjoy blazing fast video compression right from your phone!
