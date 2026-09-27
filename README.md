# install-eeglab-matlab

一键自动下载并安装 [EEGLAB](https://sccn.ucsd.edu/eeglab/) 到 MATLAB：下载 ZIP → 解压 → 加入搜索路径 → 启动 EEGLAB。

## 快速开始

1. 把 `install_eeglab.m` 放到 MATLAB 当前工作目录（或直接粘贴到命令行窗口运行）；
2. 运行：

```matlab
install_eeglab
```

3. 完成后 EEGLAB 主界面自动打开；路径已用 `savepath` 保存，下次启动 MATLAB 直接可用。

## 指定版本安装

```matlab
install_eeglab('2025.1.0')   % 安装指定版本（必须为 SCCN 已发布版本）
```

不传参数时从官网 `eeglab_current.zip` 下载最新稳定版（当前为 EEGLAB 2026.0.0）。

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
