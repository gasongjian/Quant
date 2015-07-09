function SaveFuturesDay(code_info)
% 默认更新主力合约数据，可自行调整为其他数据
%
%
%   J.Song  beta1.0 @JuLong  @2015.04.03

if nargin==0
    load code_id
    n=size(code_id,1);
    code_info=cell(n-1,1);
    for i=2:n
     code_info{i-1}=[code_id{i,1},'0'];
    end
end

fprintf('============[期货日数据更新 %s]==============\n',datestr(date,'yyyy/mm/dd'));
tic
n=length(code_info);
filedir=[pwd,'\matdata_sina\'];
if ~isdir(filedir)
    mkdir(filedir)
end

for i=1:n  
   code=code_info{i};   
   matdata=GetFutureWeb_ls(code);
   if isempty(matdata)
       fprintf('%s(%d/%d) 的数据下载失败.\n',code,i,n);
   end
   save([filedir,code,'.mat'],'matdata');
   fprintf('%s(%d/%d) 的数据已下载完毕.\n',code,i,n);
end
t=toc;
fprintf('============[更新完毕，耗时%.2f 秒]==============\n',t);
   
