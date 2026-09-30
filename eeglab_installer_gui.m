function eeglab_installer_gui()
% EEGLAB_INSTALLER_GUI  EEGLAB 图形化安装助手
%
% 版本: V1.0
%
% 运行后弹出安装窗口:
%   - 选择"最新稳定版"或从下拉框选择近 5 年发布的指定版本,一键安装
%   - 可自定义安装目录,查看实时安装日志与状态
%
% 用法:  eeglab_installer_gui
%
% 要求: MATLAB R2016b 及以上,能访问 sccn.ucsd.edu
%
% ------------------------------------------------------------------
% 版式(像素,窗口 540 x 660,原点左下):
%
%   y=590~660  顶部标题栏(深蓝):标题 + 副标题 + V1.0 徽标
%   y=444~580  卡片1「安装版本」:单选组(最新/指定+下拉框)+进度条+主按钮
%   y=296~432  卡片2「安装选项」:安装目录行 + 两个复选框 + 提示行
%   y= 96~284  卡片3「安装日志」:日志列表 + 清空按钮
%   y= 44~ 80  底部状态条(随状态变色)
%   y=  8~ 38  页脚(来源说明,居中)
% ------------------------------------------------------------------

    APP_VER = 'V1.0';

    % ---------- SCCN 官网近 5 年发布版本(新 -> 旧) ----------
    VERSIONS = {'2026.0', '2025.1', '2025.0', '2024.2', '2024.1', '2024.0', ...
                '2023.1', '2023.0', '2022.1', '2022.0', '2021.1', '2021.0'};
    LATEST_URL = 'https://sccn.ucsd.edu/eeglab/currentversion/eeglab_current.zip';

    % ---------- 配色 ----------
    C_FIG     = [0.93 0.93 0.93];   % 窗口底色
    C_CARD    = [1.00 1.00 1.00];   % 卡片底色
    C_HEADER  = [0.12 0.30 0.55];   % 顶部深蓝
    C_SUBTX   = [0.78 0.84 0.93];   % 副标题浅蓝灰
    C_BADGE   = [0.30 0.50 0.78];   % 版本徽标底
    C_ACCENT  = [0.10 0.50 0.85];   % 主按钮蓝
    C_GRAY_TX = [0.45 0.45 0.45];   % 次要文字灰
    C_TITLE_TX= [0.25 0.25 0.25];   % 卡片标题深灰
    % 状态条配色: {背景, 文字}
    ST_IDLE = {[0.90 0.90 0.90], [0.35 0.35 0.35]};
    ST_BUSY = {[1.00 0.93 0.78], [0.55 0.35 0.05]};
    ST_OK   = {[0.86 0.95 0.86], [0.08 0.45 0.08]};
    ST_ERR  = {[1.00 0.88 0.88], [0.65 0.10 0.10]};

    % ================= 主窗口 =================
    fig = figure('Name', ['EEGLAB 安装助手 ' APP_VER], ...
                 'NumberTitle', 'off', ...
                 'MenuBar', 'none', ...
                 'ToolBar', 'none', ...
                 'Position', [300 120 540 660], ...
                 'Resize', 'off', ...
                 'Color', C_FIG, ...
                 'CloseRequestFcn', @onClose);
    movegui(fig, 'center');

    % ================= 顶部标题栏 y=590~660 =================
    hdr = uipanel(fig, 'Units', 'pixels', ...
                  'Position', [0 590 541 70], ...
                  'BorderType', 'none', ...
                  'BackgroundColor', C_HEADER);
    % 主标题: x=24~404
    uicontrol(hdr, 'Style', 'text', 'Units', 'pixels', ...
              'Position', [24 30 380 30], ...
              'String', 'EEGLAB 安装助手', ...
              'FontSize', 17, 'FontWeight', 'bold', ...
              'ForegroundColor', 'white', ...
              'BackgroundColor', C_HEADER, ...
              'HorizontalAlignment', 'left');
    % 副标题: x=24~404,与主标题无重叠
    uicontrol(hdr, 'Style', 'text', 'Units', 'pixels', ...
              'Position', [24 12 380 16], ...
              'String', '一键下载 · 解压 · 配置 MATLAB 路径', ...
              'FontSize', 9, ...
              'ForegroundColor', C_SUBTX, ...
              'BackgroundColor', C_HEADER, ...
              'HorizontalAlignment', 'left');
    % 版本徽标: x=462~516,独立区域
    uicontrol(hdr, 'Style', 'text', 'Units', 'pixels', ...
              'Position', [462 24 54 22], ...
              'String', APP_VER, ...
              'FontSize', 11, 'FontWeight', 'bold', ...
              'ForegroundColor', 'white', ...
              'BackgroundColor', C_BADGE, ...
              'HorizontalAlignment', 'center');

    % ================= 卡片1:安装版本 y=444~580 =================
    pnlVer = uipanel(fig, 'Title', '安装版本', 'Units', 'pixels', ...
                     'Position', [16 444 508 136], ...
                     'BackgroundColor', C_CARD, ...
                     'FontSize', 10, 'FontWeight', 'bold', ...
                     'ForegroundColor', C_TITLE_TX);
    % 单选组(卡片内 y=52~108)
    grp = uibuttongroup('Parent', pnlVer, 'Units', 'pixels', ...
                        'Position', [12 52 484 56], ...
                        'BorderType', 'none', ...
                        'BackgroundColor', C_CARD, ...
                        'SelectionChangedFcn', @onSelChange);
    % 组内:最新版单选(组内 y=32~52 -> 卡片内 y=84~104)
    rLatest = uicontrol(grp, 'Style', 'radiobutton', 'Units', 'pixels', ...
                        'Position', [8 32 460 20], ...
                        'String', '最新稳定版(推荐) —— 从 SCCN 官网自动获取', ...
                        'BackgroundColor', C_CARD, 'Value', 1);
    % 组内:指定版本单选(组内 y=8~28 -> 卡片内 y=60~80)
    rSpec = uicontrol(grp, 'Style', 'radiobutton', 'Units', 'pixels', ...
                      'Position', [8 8 150 20], ...
                      'String', '指定历史版本:', ...
                      'BackgroundColor', C_CARD);
    % 版本下拉框(卡片内 y=58~80),与单选文字行对齐,x 起于 176 避免重叠
    popVer = uicontrol(pnlVer, 'Style', 'popupmenu', 'Units', 'pixels', ...
                       'Position', [176 58 308 22], ...
                       'String', VERSIONS, 'FontSize', 10, ...
                       'Enable', 'off', ...
                       'BackgroundColor', 'white');
    % 不确定进度条(卡片内 y=42~48),单选组下方,独立一行
    axProg = axes('Parent', pnlVer, 'Units', 'pixels', ...
                  'Position', [12 42 484 6], ...
                  'XLim', [0 484], 'YLim', [0 1], ...
                  'XTick', [], 'YTick', [], 'Box', 'on', ...
                  'Color', [0.90 0.90 0.90], ...
                  'Visible', 'off');
    barPatch = patch('Parent', axProg, ...
                     'XData', [0 130 130 0], 'YData', [0 0 1 1], ...
                     'FaceColor', C_ACCENT, 'EdgeColor', 'none', ...
                     'Visible', 'off');
    % 主按钮(卡片内 y=10~38),进度条下方,独立一行
    btnInstall = uicontrol(pnlVer, 'Style', 'pushbutton', 'Units', 'pixels', ...
                           'Position', [12 10 484 28], ...
                           'String', '开 始 安 装', ...
                           'FontSize', 11, 'FontWeight', 'bold', ...
                           'ForegroundColor', 'white', ...
                           'BackgroundColor', C_ACCENT, ...
                           'Callback', @onInstall);

    % ================= 卡片2:安装选项 y=296~432 =================
    pnlOpt = uipanel(fig, 'Title', '安装选项', 'Units', 'pixels', ...
                     'Position', [16 296 508 136], ...
                     'BackgroundColor', C_CARD, ...
                     'FontSize', 10, 'FontWeight', 'bold', ...
                     'ForegroundColor', C_TITLE_TX);
    % 安装目录行(卡片内 y=82~106):标签 x=12~88,输入框 x=92~398,按钮 x=406~484
    uicontrol(pnlOpt, 'Style', 'text', 'Units', 'pixels', ...
              'Position', [12 84 76 20], ...
              'String', '安装目录:', ...
              'BackgroundColor', C_CARD, ...
              'HorizontalAlignment', 'left');
    edtDir = uicontrol(pnlOpt, 'Style', 'edit', 'Units', 'pixels', ...
                       'Position', [92 82 306 24], ...
                       'String', fullfile(userpath, 'eeglab'), ...
                       'BackgroundColor', 'white', ...
                       'HorizontalAlignment', 'left');
    btnBrowse = uicontrol(pnlOpt, 'Style', 'pushbutton', 'Units', 'pixels', ...
                          'Position', [406 82 78 24], ...
                          'String', '浏览...', ...
                          'Callback', @onBrowse);
    % 复选框行(卡片内 y=32~76),各占一行
    chkSave = uicontrol(pnlOpt, 'Style', 'checkbox', 'Units', 'pixels', ...
                        'Position', [12 56 470 20], ...
                        'String', '保存 MATLAB 搜索路径(savepath),下次启动自动可用', ...
                        'BackgroundColor', C_CARD, 'Value', 1);
    chkLaunch = uicontrol(pnlOpt, 'Style', 'checkbox', 'Units', 'pixels', ...
                          'Position', [12 32 470 20], ...
                          'String', '安装完成后自动启动 EEGLAB', ...
                          'BackgroundColor', C_CARD, 'Value', 1);
    % 提示行(卡片内 y=10~28),小字灰色
    uicontrol(pnlOpt, 'Style', 'text', 'Units', 'pixels', ...
              'Position', [12 10 470 18], ...
              'String', '提示:安装包约 100+ MB,下载需要一定时间,请耐心等待。', ...
              'FontSize', 8, 'ForegroundColor', C_GRAY_TX, ...
              'BackgroundColor', C_CARD, ...
              'HorizontalAlignment', 'left');

    % ================= 卡片3:安装日志 y=96~284 =================
    pnlLog = uipanel(fig, 'Title', '安装日志', 'Units', 'pixels', ...
                     'Position', [16 96 508 188], ...
                     'BackgroundColor', C_CARD, ...
                     'FontSize', 10, 'FontWeight', 'bold', ...
                     'ForegroundColor', C_TITLE_TX);
    % 日志列表(卡片内 y=36~158)
    logBox = uicontrol(pnlLog, 'Style', 'listbox', 'Units', 'pixels', ...
                       'Position', [10 36 488 122], ...
                       'String', {'就绪。请选择安装方式后点击"开始安装"。'}, ...
                       'Max', 2, ...
                       'BackgroundColor', 'white');
    % 清空按钮(卡片内 y=8~30),右下角独立
    btnClear = uicontrol(pnlLog, 'Style', 'pushbutton', 'Units', 'pixels', ...
                         'Position', [388 8 110 22], ...
                         'String', '清空日志', ...
                         'Callback', @onClearLog);

    % ================= 底部状态条 y=44~80 =================
    statusBar = uicontrol(fig, 'Style', 'text', 'Units', 'pixels', ...
                          'Position', [0 44 541 36], ...
                          'String', '就 绪', ...
                          'FontSize', 10, 'FontWeight', 'bold', ...
                          'ForegroundColor', ST_IDLE{2}, ...
                          'BackgroundColor', ST_IDLE{1});

    % ================= 页脚 y=8~38 =================
    uicontrol(fig, 'Style', 'text', 'Units', 'pixels', ...
              'Position', [0 10 541 24], ...
              'String', '安装包来源: SCCN / UCSD 官网 (sccn.ucsd.edu)', ...
              'FontSize', 8, 'ForegroundColor', C_GRAY_TX, ...
              'BackgroundColor', C_FIG, ...
              'HorizontalAlignment', 'center');

    % ================= 进度条动画定时器 =================
    barPos = 0; barDir = 1;
    progTimer = timer('ExecutionMode', 'fixedRate', ...
                      'Period', 0.05, ...
                      'TimerFcn', @(~, ~)moveBar());

    logMsg(['EEGLAB 安装助手 ' APP_VER ' 已启动。']);

    % ================= 内部函数 =================
    function onSelChange(~, ~)
        % 单选切换时,启用/禁用版本下拉框
        if get(rSpec, 'Value')
            set(popVer, 'Enable', 'on');
        else
            set(popVer, 'Enable', 'off');
        end
    end

    function onBrowse(~, ~)
        d = uigetdir(get(edtDir, 'String'), '选择 EEGLAB 安装目录');
        if ischar(d) && ~isempty(d)
            set(edtDir, 'String', fullfile(d, 'eeglab'));
        end
    end

    function onClearLog(~, ~)
        set(logBox, 'String', {'日志已清空。'}, 'Value', 1);
    end

    function onInstall(~, ~)
        if get(rLatest, 'Value')
            verLabel = '最新版';
            zipUrl = LATEST_URL;
        else
            ver = VERSIONS{get(popVer, 'Value')};
            verLabel = ['v' ver];
            zipUrl = ['https://sccn.ucsd.edu/eeglab/download/daily/eeglab' ver '.zip'];
        end
        doInstall(verLabel, zipUrl);
    end

    function moveBar()
        % 不确定进度条来回滚动
        barPos = barPos + 14 * barDir;
        if barPos >= 354
            barPos = 354; barDir = -1;
        elseif barPos <= 0
            barPos = 0; barDir = 1;
        end
        if ishandle(barPatch)
            set(barPatch, 'XData', barPos + [0 130 130 0]);
        end
    end

    function startProg()
        set(axProg, 'Visible', 'on');
        set(barPatch, 'Visible', 'on');
        barPos = 0; barDir = 1;
        start(progTimer);
    end

    function stopProg()
        try stop(progTimer); catch, end
        if ishandle(barPatch), set(barPatch, 'Visible', 'off'); end
        if ishandle(axProg),   set(axProg,   'Visible', 'off'); end
    end

    function setStatus(txt, st)
        set(statusBar, 'String', txt, ...
                       'BackgroundColor', st{1}, ...
                       'ForegroundColor', st{2});
        drawnow;
    end

    function setBusy(busy)
        if busy, en = 'off'; else, en = 'on'; end
        set([btnInstall, popVer, rLatest, rSpec, edtDir, ...
             btnBrowse, chkSave, chkLaunch, btnClear], 'Enable', en);
        if strcmp(en, 'on')
            onSelChange();  % 恢复下拉框跟随单选的状态
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
        setStatus('正在安装…', ST_BUSY);
        try
            if ~isempty(which('eeglab'))
                logMsg('检测到 EEGLAB 已在搜索路径中,跳过下载。');
                setStatus('已安装,直接启动', ST_OK);
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

            logMsg(['开始下载 EEGLAB ' verLabel ' ...']);
            startProg();
            websave(zipFile, zipUrl);
            stopProg();
            logMsg('下载完成,正在解压 ...');

            unzip(zipFile, installRoot);
            sub = dir(fullfile(installRoot, 'eeglab*'));
            sub = sub([sub.isdir]);
            if isempty(sub)
                eeglabDir = installRoot;
            else
                eeglabDir = fullfile(installRoot, sub(1).name);
            end

            addpath(eeglabDir);
            logMsg(['已加入搜索路径: ' eeglabDir]);
            if get(chkSave, 'Value')
                try
                    savepath;
                    logMsg('搜索路径已保存,下次启动 MATLAB 自动可用。');
                catch
                    logMsg('警告: savepath 失败(可能需要管理员权限),请手动: Home -> Set Path 添加路径。');
                end
            end

            if exist(zipFile, 'file')
                delete(zipFile);
            end

            logMsg(['EEGLAB ' verLabel ' 安装成功!']);
            setStatus('安装成功', ST_OK);
            if get(chkLaunch, 'Value')
                logMsg('正在启动 EEGLAB ...');
                eeglab;
            end
        catch ME
            stopProg();
            logMsg(['安装失败: ' ME.message]);
            logMsg('请检查网络连接,或换一个版本重试。');
            setStatus('安装失败', ST_ERR);
        end
        setBusy(false);
    end

    function onClose(~, ~)
        % 关闭窗口时清理定时器,避免后台残留
        try
            stop(progTimer); delete(progTimer);
        catch
        end
        delete(fig);
    end
end
