function nind=Kselect(varargin)
%  FUNCTION nind=Kselect(varargin)
%  股票筛选函数
%  Kselect(ind,'概念',{'迪斯尼'},'价格',[1,10]); ind缺省为所有A股
%  Kselect(ind,@myfun,domain,''); 支持自定义函数句柄
%    单个domain 内部的关系是或

%  ind 为初始的清单，nind为筛选后的清单

load code_info
%% 初始化股票选择范围ind
if mod(nargin,2)==0
    ind=code_info(:,1);
    var=varargin;
else
    ind=varargin{1};
    var=varargin{2:end};
    
end
d=length(var);
if d==0
    nind=ind;
    disp('请添加筛选条件！')
    return
end
%% 逐个筛选
filedir2=[pwd,'\matdata_bk\'];
nind=ind;
for ii=1:d/2
    Cond=var{ii*2-1};
    domain=var{ii*2};
    %判断是否为函数句柄
    if isa(Cond,'function_handle')
        output=feval(Cond,nind);
        if iscell(domain)
            [~,ia,~]=intersect(output,domain);
            tind=nind(ia);
        elseif isdouble(domain)
            tind=nind(find((output<=domain(2))&(output>=domain(1))));
        else
            error('未定义的条件，如有需要请联系作者添加。')
        end
        nind=intersect(ind,tind);
        continue
    end
    switch Cond
        case {'MACD','macd'}
            disp('待添加')
        case {'KDJ','kdj'}
            disp('待添加')
        case {'gainian','gn','概念'}
            tind=code_info(cellfind(code_info(:,5),domain),1);
            nind=intersect(nind,tind);
        case {'hangye','hy','行业'}
            tind=code_info(cellfind(code_info(:,4),domain),1);
            nind=intersect(ind,tind);
        case {'price'}           
            load([filedir2,'K00.mat']);
            code_temp=K00.codeinfo;
            temp=K00.matdata;temp=temp(:,13:15);
            [~,~,ib]=intersect(nind,code_temp);
            nind=code_temp(ib,1);
            temp=temp(ib,:);
            nind=nind((temp(:,1)>=domain(1))&(temp(:,1)<=domain(2)),1);
        case {'zf'}
            load([filedir2,'K00.mat']);
            code_temp=K00.codeinfo;
            temp=K00.matdata;temp=temp(:,13:15);
            [~,~,ib]=intersect(nind,code_temp);
            nind=code_temp(ib,1);
            temp=temp(ib,:);
            nind=nind((temp(:,3)>=domain(1))&(temp(:,3)<=domain(2)),1);
        case {'volume'}
            load([filedir2,'K00.mat']);
            code_temp=K00.codeinfo;
            temp=K00.matdata;temp=temp(:,13:15);
            [~,~,ib]=intersect(nind,code_temp);
            nind=code_temp(ib,1);
            temp=temp(ib,:);
            nind=nind((temp(:,2)>=domain(1))&(temp(:,2)<=domain(2)),1);
            
        case {'上指相关性'}
            disp('待添加')
            
        case {'深指相关性'}
            disp('待添加')
            
        otherwise
            error('未定义的条件，如有需要请联系作者添加。')
    end
end

