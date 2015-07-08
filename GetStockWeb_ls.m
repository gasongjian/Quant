function [stock_data,StatusOut]=GetStockWeb_ls(stock_code,varargin);
%  获取股票历史数据
%  [stock_data,StatusOut]=GetStockWeb_ls(stock_code,b_date,e_date);
%  参数含义：
%  stock_code:字符阵列型，表示证券代码，如sh600000 ，sz000001 (只支持这种代码)
%  b_date:字符阵列型，表示希望获取股票数据所在时段的开始日期，如'19900215'
%  e_date:字符阵列型，表示希望获取股票数据所在时段的结束日期 ,如'20141022'
%  时间转换可以用datestr 函数，如：
%           datestr(stock_data(1,1))
%           datestr(stock_date(1,1),'yyyy-mm-dd')
%           datenum(stock_date(1,1))
%
%
%  函数输出(若获取失败，则返回空，StatusOut记录错误产生的原因)
%  第一列： Matlab的时间格式；
%  第二列： 开盘价；
%  第三列： 最高价；
%  第四列： 收盘价；
%  第五列： 最低价；
%  第六列： 交易额.

%  example;
%      stock_data=GetStockWeb_ls('sh600000');
%      stock_data=GetStockWeb_ls('sh600000','20120101','20121231');
%      
%   J.Song  beta1.0 @Scorpion  @2014.12.24


%%
if  (nargin==1)
      e_date=datestr(date,'yyyymmdd');
      b_date='19900101';
      %filename=[stock_code, '_',end_date,'.xls'];   
elseif  (nargin==3)
   b_date=varargin{1} ;
   e_date= varargin{2} ;
   %filename=[stock_code, '_',begin_date,'_',end_date,'.xls'];
elseif nargin==2
    d=varargin{1};
    e_date=datestr(date,'yyyymdd');
    b_date=datestr(addtodate(date,-d+1,'day'),'yyyy/mm/dd');
end
%% 从API中获取数据
%http://biz.finance.sina.com.cn
stock_code='sh000001';b_date='20140101';e_date='20150327';
url=['http://biz.finance.sina.com.cn/stock/flash_hq/kline_data.php?symbol=' stock_code '&end_date=' e_date '&begin_date=' b_date];
try
xmldata=urlread(url,'Timeout',60);
catch err
    StatusOut=['ERROR::urlread::',err.message];
    stock_data=[];
    return
end
[ind_s,ind_e]=regexp(xmldata,'"([0-9-.]{0,})"','start','end');
n=length(ind_s);
if n>1    
ind_s(1)=[];ind_e(1)=[];
n=n-1;
end
if (n==0)|| mod(n,7)~=0
    stock_data=[];
    StatusOut='ERROR::regexp';
    return
end
StatusOut=[];    
d=n/7;
stock_data=zeros(d,6);
%% 获取时间并转化为Matlab时间数据
a=ind_s(1:7:n)'+1;len=10;
ind=repmat(a,[1 len])+repmat([0:len-1],[d,1]);
stock_data(:,1)=datenum(xmldata(ind));
%% 获取其他五列数据
for i=1:d
    for j=2:6    
    ind=[ind_s((i-1)*7+j)+1:ind_e((i-1)*7+j)-1];
    stock_data(i,j)=str2double(xmldata(ind));
    end
end
