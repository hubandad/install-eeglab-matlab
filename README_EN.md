# install-eeglab-matlab

> Current version: V1.0

Automatically download and install [EEGLAB](https://sccn.ucsd.edu/eeglab/) into MATLAB: download ZIP → extract → add to search path → launch EEGLAB.

Two ways to use it: a **graphical installer (GUI)** and a command-line function.

> 中文版说明请见 [README.md](README.md).

## Option 1: GUI (recommended)

Run:

```matlab
eeglab_installer_gui
```

In the window that opens:

- Click **"下载安装最新版" (Install Latest)** to install the latest stable release from the SCCN website (currently EEGLAB 2026.0.0)
- Or pick a specific release from the dropdown (12 releases from the past 5 years, 2021.0 – 2026.0) and click **"安装所选版本" (Install Selected Version)**
- Customize the install folder, toggle "save search path" and "launch EEGLAB after install"
- The log panel shows real-time progress of download / extraction / path setup

## Option 2: Command line

```matlab
install_eeglab                % install the latest release
install_eeglab('2025.1.0')    % install a specific release (must be published by SCCN)
```

## Features

- Skips download and launches directly if `eeglab` is already on the search path
- Installs to `userpath/eeglab`; the downloaded ZIP is cleaned up afterwards
- Warns with manual instructions if `savepath` fails (e.g. insufficient permissions)

## Requirements

- MATLAB R2016b or later (`websave` is used)
- Internet access to `sccn.ucsd.edu`

## Notes

- EEGLAB needs no installer binary — it is essentially "extract + add to path"
- The download is 100+ MB, please be patient
- Downloading the ZIP directly from GitHub is discouraged by the EEGLAB team (missing submodules); this tool uses the official release packages, so it is not affected
