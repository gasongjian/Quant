% Saveinfo_all.m
%  更新公司基本信息
%
% 
% 
%
%   J.Song  beta1.0 @Scorpion  @2015.03.27


load code_info.mat
filedir=[pwd,'\matdata_d\'];
code_list=dir([filedir,'*.mat']);
n=length(code_list);
tt=0;
for i=2768:n
    
    tic
    
    code=code_list(i).name;
    code1=code(1:strfind(code,'.')-1);
    ind=cellfind(code_info(:,1),code1);
    if isempty(ind)
        disp(i);
        continue
    end
    type=code_info{ind,3};  
    m=matfile([filedir,code],'Writable',true);
    matinfo=m.matinfo;
    fname=fieldnames(matinfo);
    if ismember('basic',fname)
        disp(i);
        continue
    end
     if isequal(type,'zs')
         m.matinfo=matinfo;
         disp(i);
        continue
    end
    
    com_info=GetInfoWeb(code1);
    if ~isempty(com_info)
        matinfo.basic=com_info.basic;
        matinfo.hy=com_info.hy;
        matinfo.gn=com_info.gn;
        matinfo.gd=com_info.gd;
    end
    m.matinfo=matinfo;
    tt=tt+toc;
    fprintf('%s(%d/%d)的基本信息已更新,还需%.2f min. \n',code1,i,n,tt*(n-i)/i/60);
end

