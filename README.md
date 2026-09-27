# install-eeglab-matlab

一键自动下载并安装 [EEGLAB](https://sccn.ucsd.edu/eeglab/) 到 MATLAB：下载 ZIP → 解压 → 加入搜索路径 → 启动 EEGLAB。

提供两种使用方式：**图形界面（GUI）** 和命令行函数。

## 方式一：图形界面（推荐）

运行：

```matlab
eeglab_installer_gui
```

在弹出的窗口中：

- 点击「下载安装最新版」一键安装官网最新稳定版（当前为 EEGLAB 2026.0.0）
- 或从下拉框选择近 5 年发布的指定版本（2021.0 ~ 2026.0），点击「安装所选版本」
- 可自定义安装目录，勾选「保存搜索路径」和「安装完成后启动 EEGLAB」
- 下方日志区实时显示下载/安装进度

## 方式二：命令行

```matlab
install_eeglab                % 安装最新版
install_eeglab('2025.1.0')    % 安装指定版本（必须为 SCCN 已发布版本）
```

## 功能

- 已检测到 `eeglab` 在搜索路径中时，跳过下载直接启动
- 安装到 `userpath/eeglab`，下载包用后自动清理
- `savepath` 失败（如权限不足）会给出手动加路径的提示

## 要求

- MATLAB R2016b 及以上（用到 `websave`）
- 能访问 `sccn.ucsd.edu`

## 说明

- EEGLAB 本质是"解压 + 加路径"，无需安装程序
- 下载约 100+ MB，请耐心等待
- 官方不建议从 GitHub 直接下载 ZIP（缺少子模块），本脚本使用官网发布包，不受影响
