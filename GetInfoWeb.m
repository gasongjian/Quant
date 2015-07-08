function [com_info]=GetInfoWeb(stock_code,varargin)
 
% 
% 
%  @h.l. 2015.01.12
%   See also GetStock_ls


next=zeros(1,4);
if nargin==1
    next(:,:)=1;
end
for i=1:nargin-1
    % if nargin==2
    switch varargin{i}
        case 'basic', next(1)=1;% basic information
        case 'hy', next(2)=1;% industry
        case 'gd', next(3)=1;% shareholder
        case 'gn', next(4)=1;% concept
    end
end

%stock_code='sh600137';
code=stock_code(3:end);
com_info=struct;

%% get the basic information
%code='600000';
if(next(1)==1)
    url=['http://vip.stock.finance.sina.com.cn/corp/go.php/vCI_CorpInfo/stockid/',code,'.phtml'];
    try
    htmldata1=urlread(url,'Charset','gb2312','Timeout',60);
    catch err
        disp(err.identifier);
        disp(err.message);
        return;
    end
    htmldata1=regexp(htmldata1,'<!--公司简介begin-->(.*?) <!--公司简介end-->','tokens');
    htmldata1=htmldata1{1}{1};
    htmldata1=regexprep(htmldata1,'(</a>)|(<a href=.*?>)|(&nbsp;)','');
    htmldata1=regexp(htmldata1,'<tr>(.*?)</tr>','tokens');
    htmldata1(end)=[]; len_info=length(htmldata1);basic_info=cell(len_info,4);
    for i=1:len_info
        temp=htmldata1{i}{1};
        temp=regexprep(temp,'(<tr>)|(</tr>)','');
        temp=regexp(temp,'>\s{0,}(.*?)\s{0,}</td>','tokens');
        for j=1:length(temp)
            basic_info{i,j}=temp{j}{1};
        end
    end
    com_info.basic=basic_info;   
end

%% test:: 行业分类和相应的概念
%code='600028';
if(next(2)==1)
    url=['http://vip.stock.finance.sina.com.cn/corp/go.php/vCI_CorpOtherInfo/stockid/',code,'/menu_num/2.phtml'];
    %url='www.dgs';
    try
    htmldata1=urlread(url,'Charset','gb2312','Timeout',60);
    catch err
        disp(err.identifier);
        disp(err.message);
        return;
    end
    htmldata1=regexp(htmldata1,'<!--公司简介begin-->(.*?) <!--公司简介end-->','tokens');
    htmldata1=htmldata1{1}{1};
    htmldata1=regexprep(htmldata1,'(</a>)|(<a href=.*?>)|(&nbsp;)','');
    htmldata1=regexp(htmldata1,'<table.*?>(.*?)</table>','tokens');
    htmldata1_1=htmldata1{1}{1};htmldata1_2=htmldata1{2}{1};
    % 待写
    htmldata1_1=regexp(htmldata1_1,'<tr>(.*?)</tr>','tokens');
    htmldata1_1(1:2)=[];htmldata1_1(end)=[];
    len_info=length(htmldata1_1);hangye_info=cell(len_info,1);
    for i=1:len_info
        temp=htmldata1_1{i}{1};
        %temp=regexprep(temp,'(<tr>)|(</tr>)','');
        temp=regexp(temp,'>\s{0,}(.*?)\s{0,}</td>','tokens');
        hangye_info{i,1}=temp{1}{1};
    end
%     htmldata1_2=regexp(htmldata1_2,'<tr(.*?)</tr>','tokens');
%     htmldata1_2(1:2)=[];
%     len_info=length(htmldata1_2);
%     if len_info>1
%     gainian_info=cell(len_info-1,1);
%     for i=1:len_info
%         temp=htmldata1_2{i}{1};
%         temp=regexprep(temp,'(<tr>)|(</tr>)','');
%         temp=regexp(temp,'center">\s{0,}(.*?)\s{0,}</td>','tokens');%
%         if (iscell(temp))&&(~isempty(temp))
%         gainian_info{i,1}=temp{1}{1};
%         end
%     end
%     else
%         gainian_info={};
%     end
    com_info.hy=hangye_info;
%    com_info.gn=gainian_info;
end
%% test:: 十大股东（获取最近的那个就可以）
%code='600028';
if(next(3)==1)
    url=['http://vip.stock.finance.sina.com.cn/corp/go.php/vCI_StockHolder/stockid/',code,'/displaytype/30.phtml'];
    try
    htmldata1=urlread(url,'Charset','gb2312','Timeout',60);
    catch err
        disp(err.identifier);
        disp(err.message);
        return;
    end
    htmldata1=regexp(htmldata1,'&nbsp;&nbsp;主要股东(.*?)<!--分割数据的空行begin-->','tokens');
    htmldata1=htmldata1{1}{1};
    htmldata1=regexprep(htmldata1,'(</a>)|(<a href=.*?>)|(&nbsp;)|(<strong>)|(</strong>)','');
    htmldata1=regexp(htmldata1,'<tr(.*?)</tr>','tokens');
    htmldata1(1:5)=[];len_info=length(htmldata1);
    if len_info>0
    gudong_info=cell(len_info,5);
    for i=1:len_info
        temp=htmldata1{i}{1};
        %temp=regexprep(temp,'(<tr>)|(</tr>)','');
        temp=regexp(temp,'center">\s{0,}(.*?)\s{0,}<','tokens');
        for j=1:length(temp)
            gudong_info{i,j}=temp{j}{1};
        end
    end
    else
        gudong_info={};
    end
    com_info.gd=gudong_info;
end


%%  同花顺概念
if next(4)==1
url=['http://stockpage.10jqka.com.cn/',code,'/'];
    try
    htmldata=urlread(url,'Charset','utf8');
    catch err
        disp(err.identifier);
        disp(err.message);
        return;
    end
 temp=regexp(htmldata,'涉及概念</td><td>(.*?)</td>','tokens');
 if isempty(temp)
     return
 end
 temp=temp{1}{1};
 gn=regexp(temp,'，','split');
 gn=gn';
 com_info.gn=gn;
end

 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
    











