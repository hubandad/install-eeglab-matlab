function install_eeglab(version)
% INSTALL_EEGLAB  自动下载并安装 EEGLAB
% Author:he.yi@msn.com ©️ 2026 All rights reserved 
% 用法:
%   install_eeglab                % 安装 SCCN 官网最新稳定版
%   install_eeglab('2025.1.0')    % 安装指定版本（必须为 SCCN 已发布版本）
%
% 安装位置: fullfile(userpath, 'eeglab')
% 完成后自动把路径保存(savepath),下次启动 MATLAB 直接可用。

% ---------- 参数处理 ----------
if nargin < 1 || isempty(version)
    zipUrl = 'https://sccn.ucsd.edu/eeglab/currentversion/eeglab_current.zip';
    verStr = 'latest';
else
    verStr = strtrim(version);
    if startsWith(verStr, 'eeglab')  % 容错: 允许传入 eeglab2025.1 这样的名字
        zipName = verStr;
        if ~endsWith(lower(zipName), '.zip')
            zipName = [zipName '.zip'];
        end
    else
        zipName = sprintf('eeglab%s.zip', verStr);
    end
    zipUrl = ['https://sccn.ucsd.edu/eeglab/download/daily/' zipName];
end

% ---------- 已安装检查 ----------
if ~isempty(which('eeglab'))
    disp('EEGLAB 已在 MATLAB 搜索路径中，直接启动。');
    eeglab;
    return;
end

installRoot = fullfile(userpath, 'eeglab');
zipFile     = fullfile(userpath, 'eeglab_download.zip');
if ~exist(installRoot, 'dir')
    mkdir(installRoot);
end

% ---------- 下载 ----------
fprintf('正在下载 EEGLAB (%s)，请稍候...\n', verStr);
try
    websave(zipFile, zipUrl);
catch ME
    if exist(zipFile, 'file')
        delete(zipFile);
    end
    error(['下载失败: %s\n' ...
           '请检查网络连接或版本号是否正确，' ...
           '也可手动从 https://sccn.ucsd.edu/eeglab/download.php 下载。'], ME.message);
end

% ---------- 解压 ----------
disp('下载完成，正在解压...');
unzip(zipFile, installRoot);

% 找到解压出的 EEGLAB 主目录(通常是 eeglab20xx.x.x 这样的子文件夹)
sub = dir(fullfile(installRoot, 'eeglab*'));
sub = sub([sub.isdir]);
if isempty(sub)
    eeglabDir = installRoot;
else
    eeglabDir = fullfile(installRoot, sub(1).name);
end

% ---------- 加入 MATLAB 搜索路径并保存 ----------
addpath(eeglabDir);
try
    savepath;
catch
    warning('install_eeglab:savepath', ...
        'savepath 失败(可能需要管理员权限)，请手动: Home -> Set Path -> 添加 %s', eeglabDir);
end

% ---------- 清理并启动 ----------
if exist(zipFile, 'file')
    delete(zipFile);
end
fprintf('EEGLAB 已安装到: %s\n', eeglabDir);
eeglab;
end
