function stockdata=GetStock_ls(code,varargin)
%  从本地获取股票历史数据(速度快)
%  example:
%           %获取全部数据;
%            GetStock_ls('sh600000');
%            GetStock_ls('浦发银行');
%           %获取20日数据
%            GetStock_ls('sh600000',20);
%            GetStock_ls('浦发银行',20);
%
%
%  函数输出(若获取失败，则返回空)
%           第一列： Matlab的时间格式；
%           第二列： 开盘价；
%           第三列： 最高价；
%           第四列： 收盘价；
%           第五列： 最低价；
%           第六列： 交易额.
%
%   J.Song  beta1.1 @Scorpion  @2015.03.27



filedir=fullfile(pwd,'madata_d');

%简单的判断是否有中文字符;
if ~isempty(find(code>1000))
     load Stock_list
    ind=[sh_id;sz_id;zs_id];
    index=cellfind(ind(:,2),code);
    if ~isempty(index)
       code=ind{index(1),1};
    else
        error('股票代码错误！！')
    end
end
    
   if exist([filedir,code,'.mat'], 'file') ~= 2
      error('在本地目录下未找到数据！')
   end
   
 m=matfile([filedir,code,'.mat']);
 matinfo=m.matinfo;
 len=matinfo.size;
 if (nargin==2)&&(isa(varargin{1},'double'))
        len=min(varargin{1},len);
        stockdata=m.matdata(1:len,:);
 else
     stockdata=m.matdata;
 end
end



