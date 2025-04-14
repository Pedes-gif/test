clear;clc;
MSRP=[];MrsP=[];

%{
    ※ 全局判断条件IF_SEPERATE:
    - true时,从DIR_OTHERS读取数据绘制【其他方法】,从DIR_OUR读取数据绘制【our】;
    - false时,从DIR_OTHERS读取数据绘制【our&其他方法】;
    - 文本文件请务必保持相同格式;（OUR指标置于文本最后,不要删除项）
%}

IF_SEPERATE = false;
OUR_METHOD_NUMBER = 1; % 拼接最后n个新方法

% 是否生成大图还是四张小图
IF_OVERVIEW = false;
% IF_OVERVIEW = false;

% 父级输入目录,读取所有.txt
% DIR_OTHERS = 'C:\Users\admin\Desktop\FINAL\AnyFit-Bound1;old util scheme;\result\';
% DIR_OUR = 'C:\Users\admin\Desktop\FINAL\our_final\result_OUR\';
DIR_OTHERS = '.\result\';

% 输出图片目录
IF_SAVE = true;
% IF_SAVE = true;
OUTPUT_DIR = 'C:\Users\admin\Desktop\kkk\';

% 设置柱子颜色,颜色为RGB三原色，每个值在0~1之间即可
COLOR_1 = [0,0.4470,0.7410]; % Any-Fit
COLOR_2 = [0.8500,0.3250,0.0980]; % SPA
COLOR_3 = [0.9290,0.6940,0.1250]; % ROP
COLOR_4 = [0.4940,0.1840,0.5560]; % GS
COLOR_5 = [0.4660,0.6740,0.1880]; % OUR-gen
COLOR_6 = [248,250,13] / 255;

% COLOR_1 = [53,42,133] / 255;
% COLOR_2 = [1,104,225] / 255;
% COLOR_3 = [15,173,184] / 255;
% COLOR_4 = [190,187,95] / 255;
% COLOR_5 = [254,195,55] / 255;
% COLOR_6 = [248,250,13] / 255;


% 柱子宽度
BAR_WIDTH = 0.75;

% 图例
LEGEND = {};

% x刻度
XTickLabel_CSL = {'1-10','1-25','1-50','1-75','1-100'};
XTickLabel_TASK = {'1','2','3','4','5','6','7','8','9'};
XTickLabel_ACCESS = {'1','5','10','15','20','25','30','35','40'};
XTickLabel_PROCESSOR = {'4','8','12','16','20','24','28','32'};

% 指标个数
CSL_NUMBER = 5;
TASK_NUMBER = 9;
ACCESS_NUMBER = 9;
PROCESSOR_NUMBER = 8;

% 图表标题
TITLE_1 = '';
TITLE_2 = '';
TITLE_3 = '';
TITLE_4 = '';

% x轴LABEL
X_LABEL_CSL = ['\fontname{Times New Roman}\fontsize{32}Length of critical sections'];
X_LABEL_TASK = ['\fontname{Times New Roman}\fontsize{32}Number of tasks per processor '];
X_LABEL_ACCESS = ['\fontname{Times New Roman}\fontsize{32}Number of accesses to a resource'];
X_LABEL_PROCESSOR = ['\fontname{Times New Roman}\fontsize{32}Number of processors'];

% y轴LABEL
Y_LABEL = '\fontname{Times New Roman}\fontsize{32}Schedulability';


% CSL
if IF_OVERVIEW == true
    figure('position',[0,0,2000,1200]);
    subplot(2,2,1);
else
    figure('position',[0,0,1000,600]);
end

for j=1:CSL_NUMBER
    str_cell_1 = importdata([DIR_OTHERS,'2 3 ',num2str(j),'.txt']);
    if IF_SEPERATE == false
        split_str = split(str_cell_1(1),"  ");
        [m,n]=size(split_str); % m-1 为方法个数
        A=[];
        for i=1:m-1
            B = split(split_str(i,1)," ");
            if j == 1
                 % 拼接产生图例
                l = strip(cell2mat(B(1,:)),'right',':');
                LEGEND{end+1} = l;
            end
            B(1,:) = []; % 去掉文字头
            A = [A B];
        end
    else
        split_str_1 = split(str_cell_1(1),"  ");
        [m_1,n_1]=size(split_str_1); % m-1 为方法个数, our是最后一个方法
        
        % 新数据
        str_cell_2 = importdata([DIR_OUR,'2 3 ',num2str(j),'.txt']);
        split_str_2 = split(str_cell_2(1),"  ");
        [m_2,n_2]=size(split_str_2); % m-1 为方法个数
        A=[];
        for i=1:2 % Any-fit & SPA
            B = split(split_str_2(i,1)," ");
            if j == 1
                 % 拼接产生图例
                l = strip(cell2mat(B(1,:)),'right',':');
                LEGEND{end+1} = l;
            end
            B(1,:) = []; % 去掉文字头
            A = [A B];
        end

        for i=3:4 % ROP & GS
            B = split(split_str_1(i,1)," ");
            if j == 1
                 % 拼接产生图例
                l = strip(cell2mat(B(1,:)),'right',':');
                LEGEND{end+1} = l;
            end
            B(1,:) = []; % 去掉文字头
            A = [A B];
        end

        for i=5:6 % OUR-generic & OUR
            B = split(split_str_2(i,1)," ");
            if j == 1
                 % 拼接产生图例
                l = strip(cell2mat(B(1,:)),'right',':');
                LEGEND{end+1} = l;
            end
            B(1,:) = []; % 去掉文字头
            A = [A B];
        end
    end
    MSRP=[MSRP;A(1,:)]
    MrsP=[MrsP;A(2,:)]
end
X=1:CSL_NUMBER;
Y=cellfun(@str2num,MSRP);
h=bar(X,Y,BAR_WIDTH);
% title(TITLE_1);
set(gca,'XTickLabel',XTickLabel_CSL,'FontSize',26,'FontName','Times New Roman');
set(gca,'XGrid','on','gridlinestyle','--','Gridalpha',0.2);
set(gca,'YGrid','on','gridlinestyle','--','Gridalpha',0.2);
set(h(1),'FaceColor',COLOR_1);set(h(2),'FaceColor',COLOR_2);
set(h(3),'FaceColor',COLOR_3);set(h(4),'FaceColor',COLOR_4);
set(h(5),'FaceColor',COLOR_5);set(h(6),'FaceColor',COLOR_6);
ylim([0,1]);
xlabel(X_LABEL_CSL);ylabel(Y_LABEL);
%legend(LEGEND,'FontSize',20,'FontName','Times New Roman','NumColumns',2);
display_names = {'AnyFit', 'SPA', 'ROP', 'GS', 'RAU', 'RAF'};
legend(display_names,'FontSize',20,'FontName','Times New Roman','NumColumns',2);

if IF_SAVE == true
    if IF_OVERVIEW == false
        saveas(gcf, [OUTPUT_DIR,'csl'], 'png');
    end
end

% Task
if IF_OVERVIEW == true
    subplot(2,2,2);
else
    figure('position',[0,0,1000,600]);
end

MSRP=[];MrsP=[];LEGEND={};

for j=1:TASK_NUMBER
    str_cell_1 = importdata([DIR_OTHERS,'1 3 ',num2str(j),'.txt']);
    if IF_SEPERATE == false
        split_str = split(str_cell_1(1),"  ");
        [m,n]=size(split_str); % m-1 为方法个数, our是最后一个方法
        A=[];
        for i=1:m-1
            B = split(split_str(i,1)," ");
            if j == 1
                 % 拼接产生图例
                l = strip(cell2mat(B(1,:)),'right',':');
                LEGEND{end+1} = l;
            end
            B(1,:) = []; % 去掉文字头
            A = [A B];
        end
    else
        split_str_1 = split(str_cell_1(1),"  ");
        [m_1,n_1]=size(split_str_1); % m-1 为方法个数, our是最后一个方法
        
        % 新数据
        str_cell_2 = importdata([DIR_OUR,'1 3 ',num2str(j),'.txt']);
        split_str_2 = split(str_cell_2(1),"  ");
        [m_2,n_2]=size(split_str_2); % m-1 为方法个数
        A=[];
        for i=1:2 % Any-fit & SPA
            B = split(split_str_2(i,1)," ");
            if j == 1
                 % 拼接产生图例
                l = strip(cell2mat(B(1,:)),'right',':');
                LEGEND{end+1} = l;
            end
            B(1,:) = []; % 去掉文字头
            A = [A B];
        end

        for i=3:4 % ROP & GS
            B = split(split_str_1(i,1)," ");
            if j == 1
                 % 拼接产生图例
                l = strip(cell2mat(B(1,:)),'right',':');
                LEGEND{end+1} = l;
            end
            B(1,:) = []; % 去掉文字头
            A = [A B];
        end

        for i=5:6 % OUR-generic & OUR
            B = split(split_str_2(i,1)," ");
            if j == 1
                 % 拼接产生图例
                l = strip(cell2mat(B(1,:)),'right',':');
                LEGEND{end+1} = l;
            end
            B(1,:) = []; % 去掉文字头
            A = [A B];
        end
    end
    MSRP=[MSRP;A(1,:)]
    MrsP=[MrsP;A(2,:)]
end
X=1:TASK_NUMBER;
Y=cellfun(@str2num,MSRP);
h=bar(X,Y,BAR_WIDTH);
% title(TITLE_2)
set(gca,'XTickLabel',XTickLabel_TASK,'FontSize',26,'FontName','Times New Roman');
set(gca,'XGrid','on','gridlinestyle','--','Gridalpha',0.2);
set(gca,'YGrid','on','gridlinestyle','--','Gridalpha',0.2);

ylim([0,1]);
set(h(1),'FaceColor',COLOR_1);set(h(2),'FaceColor',COLOR_2);
set(h(3),'FaceColor',COLOR_3);set(h(4),'FaceColor',COLOR_4);
set(h(5),'FaceColor',COLOR_5);set(h(6),'FaceColor',COLOR_6);
xlabel(X_LABEL_TASK);ylabel(Y_LABEL);


%legend(LEGEND,'FontSize',20,'FontName','Times New Roman','NumColumns',2);
display_names = {'AnyFit', 'SPA', 'ROP', 'GS', 'RAU', 'RAF'};
legend(display_names,'FontSize',20,'FontName','Times New Roman','NumColumns',2);

if IF_SAVE == true
    if IF_OVERVIEW == false
        saveas(gcf, [OUTPUT_DIR,'task'], 'png');
    end
end

% Access
if IF_OVERVIEW == true
    subplot(2,2,3);
else
    figure('position',[0,0,1000,600]);
end
% subplot(2,2,3);
MSRP=[];MrsP=[];LEGEND = {};

for j=1:ACCESS_NUMBER
    if j==1
        num=num2str('1');
    else
        num=num2str((j-1)*5);
    end
    str_cell_1 = importdata([DIR_OTHERS,'3 3 ',num,'.txt']);
    if IF_SEPERATE == false
        split_str = split(str_cell_1(1),"  ");
        [m,n]=size(split_str); % m-1 为方法个数, our是最后一个方法
        A=[];
        for i=1:m-1
            B = split(split_str(i,1)," ");
            if j == 1
                 % 拼接产生图例
                l = strip(cell2mat(B(1,:)),'right',':');
                LEGEND{end+1} = l;
            end
            B(1,:) = []; % 去掉文字头
            A = [A B];
        end
    else
        split_str_1 = split(str_cell_1(1),"  ");
        [m_1,n_1]=size(split_str_1); % m-1 为方法个数, our是最后一个方法
        
        % 新数据
        str_cell_2 = importdata([DIR_OUR,'3 3 ',num,'.txt']);
        split_str_2 = split(str_cell_2(1),"  ");
        [m_2,n_2]=size(split_str_2); % m-1 为方法个数
        A=[];
        for i=1:2 % Any-fit & SPA
            B = split(split_str_2(i,1)," ");
            if j == 1
                 % 拼接产生图例
                l = strip(cell2mat(B(1,:)),'right',':');
                LEGEND{end+1} = l;
            end
            B(1,:) = []; % 去掉文字头
            A = [A B];
        end

        for i=3:4 % ROP & GS
            B = split(split_str_1(i,1)," ");
            if j == 1
                 % 拼接产生图例
                l = strip(cell2mat(B(1,:)),'right',':');
                LEGEND{end+1} = l;
            end
            B(1,:) = []; % 去掉文字头
            A = [A B];
        end

        for i=5:6 % OUR-generic & OUR
            B = split(split_str_2(i,1)," ");
            if j == 1
                 % 拼接产生图例
                l = strip(cell2mat(B(1,:)),'right',':');
                LEGEND{end+1} = l;
            end
            B(1,:) = []; % 去掉文字头
            A = [A B];
        end
    end
    MSRP=[MSRP;A(1,:)]
    MrsP=[MrsP;A(2,:)]

end
X=1:ACCESS_NUMBER;Y=cellfun(@str2num,MSRP);
h=bar(X,Y,BAR_WIDTH);
% title(TITLE_3)
set(gca,'XTickLabel',XTickLabel_ACCESS,'FontSize',26,'FontName','Times New Roman');
set(gca,'XGrid','on','gridlinestyle','--','Gridalpha',0.2);
set(gca,'YGrid','on','gridlinestyle','--','Gridalpha',0.2);
ylim([0,1]);
set(h(1),'FaceColor',COLOR_1);set(h(2),'FaceColor',COLOR_2);
set(h(3),'FaceColor',COLOR_3);set(h(4),'FaceColor',COLOR_4);
set(h(5),'FaceColor',COLOR_5);set(h(6),'FaceColor',COLOR_6);
xlabel(X_LABEL_ACCESS);ylabel(Y_LABEL);
% legend(LEGEND,'FontSize',20,'FontName','Times New Roman','Orientation','horizontal');
%legend(LEGEND,'FontSize',20,'FontName','Times New Roman','NumColumns',2);
display_names = {'AnyFit', 'SPA', 'ROP', 'GS', 'RAU', 'RAF'};
legend(display_names,'FontSize',20,'FontName','Times New Roman','NumColumns',2);
% SAVE
if IF_SAVE == true
    if IF_OVERVIEW == false
        saveas(gcf, [OUTPUT_DIR,'access'], 'png');
    end
end


% Processor
if IF_OVERVIEW == true
    subplot(2,2,4);
else
    figure('position',[0,0,1000,600]);
end

MSRP=[];MrsP=[];LEGEND = {};

for j=1:PROCESSOR_NUMBER
    num=j*4;
    str_cell_1 = importdata([DIR_OTHERS,'4 3 ',num2str(num),'.txt']);
    if IF_SEPERATE == false
        split_str = split(str_cell_1(1),"  ");
        [m,n]=size(split_str); % m-1 为方法个数, our是最后一个方法
        A=[];
        for i=1:m-1
            B = split(split_str(i,1)," ");
            if j == 1
                 % 拼接产生图例
                l = strip(cell2mat(B(1,:)),'right',':');
                LEGEND{end+1} = l;
            end
            B(1,:) = []; % 去掉文字头
            A = [A B];
        end
    else
        split_str_1 = split(str_cell_1(1),"  ");
        [m_1,n_1]=size(split_str_1); % m-1 为方法个数, our是最后一个方法
        
        % 新数据
        str_cell_2 = importdata([DIR_OUR,'4 3 ',num2str(num),'.txt']);
        split_str_2 = split(str_cell_2(1),"  ");
        [m_2,n_2]=size(split_str_2); % m-1 为方法个数
        A=[];
        for i=1:2 % Any-fit & SPA
            B = split(split_str_2(i,1)," ");
            if j == 1
                 % 拼接产生图例
                l = strip(cell2mat(B(1,:)),'right',':');
                LEGEND{end+1} = l;
            end
            B(1,:) = []; % 去掉文字头
            A = [A B];
        end

        for i=3:4 % ROP & GS
            B = split(split_str_1(i,1)," ");
            if j == 1
                 % 拼接产生图例
                l = strip(cell2mat(B(1,:)),'right',':');
                LEGEND{end+1} = l;
            end
            B(1,:) = []; % 去掉文字头
            A = [A B];
        end

        for i=5:6 % OUR-generic & OUR
            B = split(split_str_2(i,1)," ");
            if j == 1
                 % 拼接产生图例
                l = strip(cell2mat(B(1,:)),'right',':');
                LEGEND{end+1} = l;
            end
            B(1,:) = []; % 去掉文字头
            A = [A B];
        end
    end
    MSRP=[MSRP;A(1,:)]
    MrsP=[MrsP;A(2,:)]
end
X=1:PROCESSOR_NUMBER;Y=cellfun(@str2num,MSRP);
h=bar(X,Y,BAR_WIDTH);
% title(TITLE_4)
set(gca,'XTickLabel',XTickLabel_PROCESSOR,'FontSize',26,'FontName','Times New Roman');
set(gca,'XGrid','on','gridlinestyle','--','Gridalpha',0.2);
set(gca,'YGrid','on','gridlinestyle','--','Gridalpha',0.2);
ylim([0,1]);
set(h(1),'FaceColor',COLOR_1);set(h(2),'FaceColor',COLOR_2);
set(h(3),'FaceColor',COLOR_3);set(h(4),'FaceColor',COLOR_4);
set(h(5),'FaceColor',COLOR_5);set(h(6),'FaceColor',COLOR_6);
xlabel(X_LABEL_PROCESSOR);ylabel(Y_LABEL);
%legend(LEGEND,'FontSize',20,'FontName','Times New Roman','NumColumns',2);
display_names = {'AnyFit', 'SPA', 'ROP', 'GS', 'RAU', 'RAF'};
legend(display_names,'FontSize',20,'FontName','Times New Roman','NumColumns',2);
% SAVE
if IF_SAVE == true
    if IF_OVERVIEW == true
        saveas(gcf, [OUTPUT_DIR,'overview'], 'png');
    else
        saveas(gcf, [OUTPUT_DIR,'processor'], 'png');
    end
end


