function [outdata,StatusOut]=GetFutureWeb_ls(code,period);
%  1、获取历史K线数据, 数据接口为新浪财经
%  2、新浪目前连续合约只有主力合约一种(P0)，其他的就是各个年份的，如P1501
%  3、数据来源于新浪的实时图表，所以只能获取近期的数据，并不能自定义数据时间范围
%  4、目前支持 日数据(day), 5分钟(5m)，15分钟(15m),30分钟(30m),60分钟(60m)
%  5、返回数据格式： 时间  开  高  低  收  成交量
%
%
%   J.Song  beta1.0  @2015.04.13
%   J.Song  beta1.1  @2015.04.18
%   更新：
%     1、添加了对股指期货数据的获取
%     2、上一版本只支持日K线，该版本已支持5分钟、15分钟、30分钟、60分钟K线
%


if nargin==1
    period='day'; %默认获取日线
end

if strcmp(period,'day')
    period='DailyKLine';
    len=10;%时间的长度
else
    period=['MiniKLine',period];
    len=19;
end


% 判断代码的准确性和其所在的交易所(目前只支持国内的商品期货和股指期货)
url_info=['http://finance.sina.com.cn/futures/quotes/',code,'.shtml'];
try
    tmpdata=urlread(url_info,'charset','gb2312','Timeout',60);
    jys=regexp(tmpdata,'上市交易所.*?<td>(.*?)\s{0,}</td></tr>','tokens');
    if ~isempty(jys)
        jys=jys{1}{1};
    else
        fprintf('数据获取失败，请检查您的参数.\n');
        outdata=[];
        StatusOut=[];
        return
    end
    
    if strcmp(jys,'中国金融期货交易所')
        url=['http://stock2.finance.sina.com.cn/futures/api/json.php/CffexFuturesService.getCffexFutures',period,'?symbol=',code];
    else
        url=['http://stock2.finance.sina.com.cn/futures/api/json.php/IndexService.getInnerFutures',period,'?symbol=',code];
    end
    
catch err
    StatusOut=['ERROR::urlread::',err.message];
    outdata=[];
    fprintf('不明原因导致数据获取失败，请检查网络和参数.\n');
    return
end

% 异常情况处理，便于批量获取数据
try
    jsondata=urlread(url,'Timeout',60);
catch err
    StatusOut=['ERROR::urlread::',err.message];
    outdata=[];
    fprintf('%s 期货数据获取发生错误.\n',code);
    return
end


%% 经测试比用tokens的方法要快
% 因为时间转换起来很慢，所以先处理其他数据
outdata=regexp(jsondata,'"([0-9\.]{1,})"','tokens');
if isempty(outdata)
    StatusOut=['ERROR::regexp::null'];
    outdata=[];
    fprintf('%s 期货数据获取发生错误.\n',code);
    return
end
outdata=reshape(outdata',[5,length(outdata)/5]);
outdata=outdata';
outdata=cellfun(@cell2mat,outdata,'UniformOutput', false);
outdata=cellfun(@str2num,outdata,'UniformOutput', false);
outdata=cell2mat(outdata);
% 获取时间列并转换成MATLAB时间格式
ind=regexp(jsondata,'"\d{4}-\d{2}-\d{2}','start');
ind=repmat(ind'+1,[1 len])+repmat([0:len-1],[length(ind),1]);
if strcmp(period,'DailyKLine')
t=datenum(jsondata(ind),'yyyy-mm-dd');
else
t=datenum(jsondata(ind),'yyyy-mm-dd HH:MM:SS');
end
outdata=[t outdata];
StatusOut=[];


%%



