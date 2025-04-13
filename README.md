# VideoSensi Pro 🎥

**VideoSensi Pro** is a powerful and user-friendly video processing tool designed for Android (via Termux). It allows you to compress, convert, and watermark videos with ease. Built with simplicity and efficiency in mind, this tool is perfect for content creators, editors, and anyone who needs quick video processing on the go.

## Features ✨
- **Video Compression**: Compress videos with 5 quality levels (Ultra Low to Ultra High).
- **Format Conversion**: Convert videos to MP4, MKV, MOV, WEBM, and AVI formats.
- **Watermarking**: Add custom text watermarks with options to:
  - Choose size: Normal (24px), Small (28px), Medium (32px), Big (36px).
  - Choose color: White, Yellow, Cyan, Green, Magenta.
  - Choose position: Left-Down, Right-Down, Left-Up, Right-Up.
- **Custom Output Directory**: Save processed videos anywhere on your device.
- **Log Viewer**: Track all activities with detailed logs.
- **System Cleaner**: Clear old logs and output files.
- **Updates**: Check for the latest version of the tool.
- **Community Support**: Join our Telegram community for help and updates.

## Installation 📦
Follow these steps to install VideoSensi Pro on your Android device using Termux:

1. **Install Termux**:
   - Download Termux from the Google Play Store or F-Droid.
   - Open Termux and update packages:
     ```bash
     pkg update && pkg upgrade
     ```

2. **Grant Storage Permission**:
   - Run this command to allow Termux to access your storage:
     ```bash
     termux-setup-storage
     ```

3. **Install VideoSensi Pro**:
   - Run the following command to download and set up the tool:
     ```bash
     bash <(curl -s https://raw.githubusercontent.com/jubairbro/VideoSensi/main/setup.sh)
     ```

4. **Run the Tool**:
   - After installation, simply run:
     ```bash
     videosensi
     ```
   - If the above command doesn't work, try:
     ```bash
     bash $HOME/videosensi
     ```

## Usage 📖
1. Launch the tool by running `videosensi`.
2. Choose an option from the main menu:
   - **Compress Video**: Select a quality level (1-5) and provide the video path.
   - **Convert Format**: Choose a format (MP4, MKV, etc.) and provide the video path.
   - **Add Watermark**: Enter the video path, text, and customize size, color, and position.
   - Other options include changing the output directory, viewing logs, cleaning the system, checking updates, and joining the Telegram community.
3. Follow the on-screen prompts to process your videos.
4. Output files are saved in `/sdcard/VideoSensi` (or your custom directory).

## Screenshots 📸
Here’s a glimpse of VideoSensi Pro in action:

![VideoSensi Pro Screenshot](screenshots/screenshot.img)

## Example 🖼️
- **Compress a Video**:
  - Select option `1`, choose quality level `3`, and enter the video path: `/sdcard/Movies/myvideo.mp4`.
  - Output: `/sdcard/VideoSensi/myvideo_compressed_Jubairbro.mp4`
- **Add a Watermark**:
  - Select option `3`, enter video path, text (`JubairFF`), size (`Medium`), color (`Yellow`), and position (`Right-Up`).
  - Output: `/sdcard/VideoSensi/myvideo_watermarked_Jubairbro.mp4`

## Troubleshooting ⚠️
- **Permission Issues**: Ensure you have run `termux-setup-storage`.
- **FFmpeg Errors**: Check logs at `$HOME/.logs/ffmpeg_error.log`.
- **File Not Found**: Verify the video path (e.g., `/sdcard/...`).
- **Need Help?**: Join our Telegram group: [@JubairFF](https://t.me/JubairFF).

## Contributing 🤝
Feel free to fork this repository, make improvements, and submit pull requests. If you find bugs or have feature requests, open an issue on GitHub.

## License 📜
VideoSensi Pro is licensed under the [MIT License](LICENSE). You are free to use, modify, and distribute this software as per the terms of the license.

## Contact 📬
- **Author**: Jubair bro
- **Telegram**: [@JubairFF](https://t.me/JubairFF)
- **GitHub**: [jubairbro](https://github.com/jubairbro)

---

**VideoSensi Pro** - Made with ❤️ by Jubair bro
