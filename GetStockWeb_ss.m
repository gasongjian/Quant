function data=GetStockWeb_ss(stock_code,class)
%  获取股票的实时数据，支持多个股票同时查询
%  返回的是cell数组，若对应的值为0代表获取失败
%
%  example：
%       GetStockWeb_ss('sh600028')
%       GetStockWeb_ss('sh600028','zs') %指数查询，返回的结构不一样
%       GetStockWeb_ss({'sh60000','sz000001'})
%
% 1： 股票代码
% 2: "大秦铁路"，股票名字；
% 3: "27.55"，今日开盘价；
% 4: "27.25"，昨日收盘价；
% 5: "26.91"，当前价格；
% 6: "27.55"，今日最高价；
% 7: "26.20"，今日最低价；
% 8: "26.91"，竞买价，即“买一”报价；
% 9: "26.92"，竞卖价，即“卖一”报价；
% 10: "22114263"，成交的股票数，由于股票交易以一百股为基本单位，
%                所以在使用时，通常把该值除以一百；
% 11: "589824680"，成交金额，单位为“元”，为了一目了然，
%                 通常以“万元”为成交金额的单位，
%                 所以通常把该值除以一万；
% 12: 龙虎盘数据：
%      买一股数   买一报价
%      买二
%      买三
%      买四
%      买五
%      卖一股数   卖一报价
%      卖二
%      卖三
%      卖四
%      卖五
%
% 13: 查询时间, 如用datestr(data{1}{13},'yyyy-mm-dd HH:MM:SS')转换
%
%
%   
%   J.Song beta1.0 @Scorpion  @2014.12.24



if ~iscell(stock_code)
    stock_code={stock_code};
end
code=strjoin(stock_code,',');
if nargin==1
    url_s1=['http://hq.sinajs.cn/list=',code];
elseif (nargin==2)&&(strcmp(class,'zs'))
    url_s1=['http://hq.sinajs.cn/list=s_',code];
end
%url_s1='http://hq.sinajs.cn/list=sh600628,sh600000,sh600618,sh60019';
data1=urlread(url_s1);
data1=strsplit(data1,'\n');
if isempty(data1{end})
    data1(end)=[];
end
n=length(data1);
data=cell(n,1);
for j=1:n
    temp=data1{j};
    temp=strsplit(temp,',');
    if length(temp)>1
        name=regexp(temp{1},'="(.*?)$','tokens');
        name=name{1}{1};
        temp{1}=name;
        temp(end)=[];
        temp=temp(:);
        temp=[stock_code{j};temp];
        for k=3:31
            temp{k}=str2double(temp{k});
        end
        longhupan=reshape(cell2mat(temp(12:31)),[2,10])';
        rtime=datenum([temp{32},' ',temp{33}],'yyyy-mm-dd HH:MM:SS');
        data{j}=[temp(1:11);{longhupan};rtime];
    else
        data{j}=0;
    end
end


