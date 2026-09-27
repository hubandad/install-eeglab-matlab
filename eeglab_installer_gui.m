function eeglab_installer_gui()
% EEGLAB_INSTALLER_GUI  EEGLAB 图形化安装助手
% Author:he.yi@msn.com ©️ 2026 All right reserved
% 运行后弹出窗口:
%   - 点击"安装最新版"一键下载安装 SCCN 官网最新稳定版
%   - 或从下拉框选择近 5 年发布的指定版本进行安装
%
% 用法:  eeglab_installer_gui
%
% 要求: MATLAB R2016b 及以上,能访问 sccn.ucsd.edu

    % ---------- SCCN 官网近 5 年发布版本(新->旧) ----------
    % zip 包命名规则: eeglab<版本号>.zip,位于
    % https://sccn.ucsd.edu/eeglab/download/daily/
    VERSIONS = {'2026.0', '2025.1', '2025.0', '2024.2', '2024.1', '2024.0', ...
                '2023.1', '2023.0', '2022.1', '2022.0', '2021.1', '2021.0'};
    LATEST_URL = 'https://sccn.ucsd.edu/eeglab/currentversion/eeglab_current.zip';

    % ---------- 创建窗口 ----------
    fig = figure('Name', 'EEGLAB 安装助手', ...
                 'NumberTitle', 'off', ...
                 'MenuBar', 'none', ...
                 'ToolBar', 'none', ...
                 'Position', [300 200 500 500], ...
                 'Resize', 'off', ...
                 'Color', [0.94 0.94 0.94]);
    movegui(fig, 'center');

    % 标题
    uicontrol(fig, 'Style', 'text', ...
              'String', 'EEGLAB 一键安装', ...
              'FontSize', 16, 'FontWeight', 'bold', ...
              'BackgroundColor', [0.94 0.94 0.94], ...
              'Position', [20 445 460 35]);

    % ---- 最新版 ----
    uicontrol(fig, 'Style', 'text', ...
              'String', '官网最新稳定版(推荐):', ...
              'HorizontalAlignment', 'left', ...
              'BackgroundColor', [0.94 0.94 0.94], ...
              'Position', [20 415 460 20]);
    btnLatest = uicontrol(fig, 'Style', 'pushbutton', ...
              'String', '下载安装最新版', ...
              'FontSize', 11, 'FontWeight', 'bold', ...
              'Position', [20 375 460 38], ...
              'Callback', @onInstallLatest);

    % ---- 指定版本 ----
    uicontrol(fig, 'Style', 'text', ...
              'String', '或选择指定版本:', ...
              'HorizontalAlignment', 'left', ...
              'BackgroundColor', [0.94 0.94 0.94], ...
              'Position', [20 340 460 20]);
    popVer = uicontrol(fig, 'Style', 'popupmenu', ...
              'String', VERSIONS, ...
              'FontSize', 10, ...
              'Position', [20 308 320 28]);
    btnVer = uicontrol(fig, 'Style', 'pushbutton', ...
              'String', '安装所选版本', ...
              'FontSize', 10, ...
              'Position', [350 308 130 28], ...
              'Callback', @onInstallSelected);

    % ---- 安装目录 ----
    uicontrol(fig, 'Style', 'text', ...
              'String', '安装目录:', ...
              'HorizontalAlignment', 'left', ...
              'BackgroundColor', [0.94 0.94 0.94], ...
              'Position', [20 272 460 20]);
    edtDir = uicontrol(fig, 'Style', 'edit', ...
              'String', fullfile(userpath, 'eeglab'), ...
              'HorizontalAlignment', 'left', ...
              'BackgroundColor', 'white', ...
              'Position', [20 244 400 26]);
    uicontrol(fig, 'Style', 'pushbutton', ...
              'String', '浏览...', ...
              'Position', [428 244 52 26], ...
              'Callback', @onBrowse);

    % ---- 选项 ----
    chkSave = uicontrol(fig, 'Style', 'checkbox', ...
              'String', '保存 MATLAB 搜索路径(savepath,下次启动自动可用)', ...
              'Value', 1, ...
              'BackgroundColor', [0.94 0.94 0.94], ...
              'Position', [20 214 460 22]);
    chkLaunch = uicontrol(fig, 'Style', 'checkbox', ...
              'String', '安装完成后启动 EEGLAB', ...
              'Value', 1, ...
              'BackgroundColor', [0.94 0.94 0.94], ...
              'Position', [20 190 460 22]);

    % ---- 日志 ----
    uicontrol(fig, 'Style', 'text', ...
              'String', '安装日志:', ...
              'HorizontalAlignment', 'left', ...
              'BackgroundColor', [0.94 0.94 0.94], ...
              'Position', [20 160 460 20]);
    logBox = uicontrol(fig, 'Style', 'listbox', ...
              'String', {'就绪。请选择安装方式。'}, ...
              'Max', 2, ...   % 允许多行显示
              'BackgroundColor', 'white', ...
              'Position', [20 30 460 128]);

    logMsg('EEGLAB 安装助手已启动。');

    % ================= 回调函数 =================
    function onInstallLatest(~, ~)
        doInstall('最新版', LATEST_URL);
    end

    function onInstallSelected(~, ~)
        idx = get(popVer, 'Value');
        ver = VERSIONS{idx};
        url = ['https://sccn.ucsd.edu/eeglab/download/daily/eeglab' ver '.zip'];
        doInstall(['v' ver], url);
    end

    function onBrowse(~, ~)
        d = uigetdir(get(edtDir, 'String'), '选择 EEGLAB 安装目录');
        if ischar(d) && ~isempty(d)
            set(edtDir, 'String', fullfile(d, 'eeglab'));
        end
    end

    function setBusy(busy)
        % 安装过程中禁用按钮,防止重复点击
        if busy
            set([btnLatest, btnVer], 'Enable', 'off');
        else
            set([btnLatest, btnVer], 'Enable', 'on');
        end
        drawnow;
    end

    function logMsg(msg)
        stamp = datestr(now, 'HH:MM:SS');
        old = get(logBox, 'String');
        if ischar(old), old = {old}; end
        set(logBox, 'String', [old; {['[' stamp '] ' msg]}]);
        set(logBox, 'Value', numel(get(logBox, 'String')));
        drawnow;
    end

    function doInstall(verLabel, zipUrl)
        setBusy(true);
        try
            % 已安装检查
            if ~isempty(which('eeglab'))
                logMsg('检测到 EEGLAB 已在搜索路径中，跳过下载。');
                if get(chkLaunch, 'Value')
                    logMsg('正在启动 EEGLAB ...');
                    eeglab;
                end
                setBusy(false);
                return;
            end

            installRoot = strtrim(get(edtDir, 'String'));
            if isempty(installRoot)
                installRoot = fullfile(userpath, 'eeglab');
            end
            if ~exist(installRoot, 'dir')
                mkdir(installRoot);
            end
            zipFile = fullfile(installRoot, 'eeglab_download.zip');

            % 下载
            logMsg(['开始下载 EEGLAB ' verLabel ' ...']);
            logMsg('下载约 100+ MB，请耐心等待。');
            websave(zipFile, zipUrl);
            logMsg('下载完成，正在解压 ...');

            % 解压
            unzip(zipFile, installRoot);
            sub = dir(fullfile(installRoot, 'eeglab*'));
            sub = sub([sub.isdir]);
            if isempty(sub)
                eeglabDir = installRoot;
            else
                eeglabDir = fullfile(installRoot, sub(1).name);
            end

            % 加路径
            addpath(eeglabDir);
            logMsg(['已加入搜索路径: ' eeglabDir]);
            if get(chkSave, 'Value')
                try
                    savepath;
                    logMsg('搜索路径已保存，下次启动 MATLAB 自动可用。');
                catch
                    logMsg('警告: savepath 失败(可能需要管理员权限)，请手动: Home -> Set Path 添加路径。');
                end
            end

            % 清理
            if exist(zipFile, 'file')
                delete(zipFile);
            end

            logMsg(['EEGLAB ' verLabel ' 安装成功!']);
            if get(chkLaunch, 'Value')
                logMsg('正在启动 EEGLAB ...');
                eeglab;
            end
        catch ME
            logMsg(['安装失败: ' ME.message]);
            logMsg('请检查网络连接，或换一个版本重试。');
        end
        setBusy(false);
    end
end
