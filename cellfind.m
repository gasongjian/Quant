function outdata=cellfind(data,cdata,method)
%% 元胞数组的查找函数
%  个人使用所以只处理特定格式的代码查找
%  cdata 支持数组，字符，含数组和字符的元胞
if nargin==2
    method='OR';
end
data=data(:);
n=length(data);
outdata=[];

for i=1:n
    temp=data{i};
    if isempty(temp)
        continue
    end
    if ~iscell(temp)
        temp={temp};
    end
    switch method
        case {'OR','or','或'}
            if any(ismember(cdata,temp))
                outdata=[outdata;i];
            end
        case {'AND','and','和'}
            if all(ismember(cdata,temp))
                outdata=[outdata;i];
            end
    end
    
end
