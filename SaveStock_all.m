function unsucc=SaveStock_all(code_info)
%  下载或者更新所有历史数据，并保存为在[pwd,'\matdata_d\']中
%  保存格式如下：
%  sh600000.mat 
%     matdata   : 含历史数据
%     matinfo   : 含股票的各种信息
%
% 
% 
%
%   J.Song  beta1.0 @Scorpion  @2015.03.27

disp('=================【股票日数据更新】=======================')
if nargin==0
load code_info
ind=code_info(2:end,1);
else
    ind=code_info;
end
% load code_info
% ind=code_info;
n=length(ind);
unsucc=[];
filedir=[pwd,'\matdata_d\'];
if ~isdir(filedir)
    mkdir(filedir);
end
tt=0;%记录耗费的总时间
for i=1:n
    code=ind{i};
    tic
     FileString = [filedir,code,'.mat'];
     %% 如果已经有本地数据，则重新计算下载数据的区间
    if exist(FileString, 'file') == 2
        load(FileString);
        if now-matdata(end,1)<=1.75
            fprintf('股票 %s (%d / %d)的数据已经是最新的.\n',code,i,n);
            continue
        end
%         if (weekday(matdata(end,1))==6)&&((weekday(now)==7)||((weekday(now)==1)))&&(datenum(date)-matdata(end,1)<3)
%             fprintf('今天是周末，数据已最新.\n');
%             return
%         end
        
        b_date=datestr(addtodate(matdata(end,1),1,'day'),'yyyymmdd');
        e_date=datestr(date,'yyyymmdd');
      % pause(5);
    else
       matdata=[];
       matinfo=struct;
       e_date=datestr(date,'yyyymmdd');
      b_date='19900101';
    end
    
    
    [data,flag]=GetStockWeb_ls(code,b_date,e_date);
    if isempty(data)
        unsucc=[unsucc;{code,flag}];
        fprintf('股票 %s (%d / %d)的数据获取失败，请检查! \n',code,i,n);
        continue
    end
    matdata=[matdata;data];   
    % 更新matinfo信息
    matinfo.version=datestr(now,'yyyy.mm.dd.HH.MM.SS');
    matinfo.size=size(matdata,1);
    matinfo.time=[matdata(1,1);matdata(end,1)];
    matinfo.price=[matdata(1,2);max(matdata(:,3));matdata(end,4);min(matdata(:,5))];
    matinfo.zf=(matdata(end,4)-matdata(end-1,4))/matdata(end-1,4);
    save([filedir,code,'.mat'],'matdata','matinfo','-v7.3');
    tt=tt+toc;
    fprintf('已保存股票 %s (%d / %d)的数据，预计还需要 %.3f 分钟.\n',code,i,n,tt*(n-i)/i/60); 
    
end

disp('=================【股票日数据更新完毕】=======================');
disp('注1、如有没下载成功的股票数据，请用unsucc重新运行一次。')
disp('注2、如果数据更新完毕，可以运行函数：Kday_tj 来更新近五天的基本数据。')




























