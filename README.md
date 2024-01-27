# Sora Linux

[![build-ublue](https://github.com/ublue-os/startingpoint/actions/workflows/build.yml/badge.svg)](https://github.com/ublue-os/startingpoint/actions/workflows/build.yml)

## Install

- First rebase to the unsigned image, to get the proper signing keys and policies installed:
  ```
  sudo rpm-ostree rebase ostree-unverified-registry:ghcr.io/mecattaf/sora:latest
  ```

- Reboot to complete the rebase:
  ```
  systemctl reboot
  ```
- Then rebase to the signed image, like so:
  ```
  rpm-ostree rebase ostree-image-signed:docker://ghcr.io/mecattaf/sora:latest
  ```
- Reboot again to complete the installation
  ```
  systemctl reboot
  ```

### Set up dotfiles for my device
```
git clone https://github.com/mecattaf/sora
cd sora
./setup-sora.sh
```

### Manual setup using GUI

- Run `nwg-look` and set up appearance settings
- Run `azote` and pick wallpaper

### Google Chrome

1) In `chrome://settings`:

System

- Continue running background apps when Google Chrome is closed ❌
- Use hardware acceleration when available ✅

Appearance

- Theme: All Black - Full Dark Theme/Black Theme ❌
- Show home button ❌
- Show bookmarks bar ✅
- Show images on tab hover preview cards ❌
- Use system title bars and borders ✅

2) In`chrome://flags`:

- Chrome Refresh 2023 ✅
- Preferred Ozone Platform: `Wayland`
- WebRTC PipeWire support ✅
- Native Client ✅
- WebGL Developer Extensions ✅
- WebGL Draft Extensions✅
- Toggle hardware accelerated H.264 video encoding for Cast Streaming ✅
- Toggle hardware accelerated VP8 video encoding for Cast Streaming ✅

3) Add PWA's manually

The shortcuts will be created in ~/.local/share/applications

Go to Top-right menu > Save and share > Create Shortcut and make sure to enable “Open as Window”

| Application      | URL                                        |
| ---------------- | ------------------------------------------ |
| ChatGPT          | [https://chat.openai.com/](https://chat.openai.com/)        |
| Google Drive     | [https://drive.google.com/drive/u/0/](https://drive.google.com/drive/u/0/)  |
| Linear           | [https://linear.app/](https://linear.app/)              |
| Superhuman       | [https://mail.superhuman.com/](https://mail.superhuman.com/)      |
| Loom             | [https://www.loom.com/home](https://www.loom.com/home)          |
| SoundCloud       | [https://soundcloud.com/](https://soundcloud.com/)            |
| Notion Calendar  | [https://calendar.notion.so/](https://calendar.notion.so/)    |
| WhatsApp Web     | [https://web.whatsapp.com/](https://web.whatsapp.com/)        |
| Notion           | [https://notion.so/](https://notion.so/)                  |
| Google Photos    | [https://photos.google.com/](https://photos.google.com/)      |



## Verification

These images are signed with sisgstore's [cosign](https://docs.sigstore.dev/cosign/overview/). You can verify the signature by downloading the `cosign.pub` key from this repo and running the following command:

    cosign verify --key cosign.pub ghcr.io/mecattaf/SericeaFX

If you're forking this repo, the uBlue website has [instructions](https://ublue.it/making-your-own/) for setting up signing properly.

### To revert back to Silverblue

```shell
sudo rpm-ostree rebase fedora:fedora/38/x86_64/silverblue
```


