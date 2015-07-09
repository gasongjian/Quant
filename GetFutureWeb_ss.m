function outdata=GetFutureWeb_ss(code_info);
%  获取期货的实时行情函数，可以同时获取多个期货品种
%  默认获取的是所有主力合约的数据，则返回的是44*29的元胞
%  每一列的意义完全按照网站的顺序，未处理过(只在最前面加了一个期货代码)，具体含义待查。  
%  
%
%   
%   J.Song  beta1.0 @JuLong  @2015.04.03
%
%
%code_info={'P0','A0'};%测试用
if nargin==0
    load code_id
    n=size(code_id,1);
    code_info=cell(n-1,1);
    for i=2:n
     code_info{i-1}=[code_id{i,1},'0'];
    end
 end
if ~iscell(code_info)
    code_info={code_info};
end
code_info=code_info(:)';% 处理成一行
code=strjoin(code_info,',');
url=['http://hq.sinajs.cn/list=',code];
data1=urlread(url);
data1=strsplit(data1,'\n');
if isempty(data1{end})
    data1(end)=[];
end
n=length(data1);
outdata=cell(n,29);
for j=1:n
    temp=data1{j};
    temp=strsplit(temp,',');
    if length(temp)>1
        name=regexp(temp{1},'="(.*?)$','tokens');
        name=name{1}{1};
        temp{1}=name;
        temp=temp(:);
        temp=[code_info{j};temp];
        len=length(temp);
        for k=[4:16 20:len]
            temp{k}=str2double(temp{k});
        end
        outdata(j,1:len)=temp';
    end
end


