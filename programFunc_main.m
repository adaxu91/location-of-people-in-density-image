clear
clc;
close all

% setting working directory
addpath('.\\matlab\x64_win64');

%---general setting for dataset ---
height=80; %picture's height
width=100; %picture's width
wnd_size=[8,8];%window's width and height[width,height]
wnd_nmb=(width-wnd_size(1,1)+1)*(height-wnd_size(1,2)+1)/16 %number of windows
count_mode='linprog'; %invA,cvx,linprog,binprog
pedestrain_nmb=20; %the number of pedestrains in this image
s=zeros(width*height,1);

[A cgt_all n density_all]=gen_cgt(pedestrain_nmb,width,height,wnd_nmb,wnd_size);
% s=reshape(cgt_all,width*height,1);
 
switch(count_mode)
    case 'invA'
        xsol=A\n;
    case 'cvx'
        lb=ones(width*height,1)*0;  %lower bound
        ub=ones(width*height,1)*2;  %upper bound
        xsol=quadprog(2*A'*A, -2*A'*n,[],[],[],[],lb,ub ); 
    case 'linprog'
        ctype='';
        for i = 1:length(n)
            ctype(i)='C';
        end
        for i = 1+length(n):width*height+length(n)
            ctype(i) ='I';
        end
        options=cplexoptimset('cplex');
        options.mip.display=0;
        options.mip.limits.treememory=1000;
        options.mip.tolerances.mipgap=0.001;
        lb=ones(width*height+length(n),1)*0;  % lower bound
        ub=ones(width*height+length(n),1)*2;  % upper bound
        
        f=[ones(length(n),1);zeros(width*height,1)];
        Aineq=[-eye(length(n)),A;-eye(length(n)),-A];
        bineq=[n;-n];
        x=cplexmilp(f,Aineq,bineq,[],[],[],[],[],lb,ub,ctype,[],options);
        xsol=x(length(n)+1:width*height+length(n));
    case 'binprog'
        ctype0='';
        for i = 1:length(n)
            ctype0(i)='C';
        end
        for i = 1+length(n):width*height+length(n)
            ctype0(i) ='I';
        end
        ctype='';
        for i = 1:width*height
            ctype(i)='I';
        end
        options=cplexoptimset('cplex');
        options.mip.display=0;
        options.mip.limits.treememory=1000;
        options.mip.tolerances.mipgap=0.001;
        lb=ones(width*height+length(n),1)*0;  % lower bound
        ub=ones(width*height+length(n),1)*2;  % upper bound
%         H=2*A'*A;
%         f=-2*A'*n;       
%         x0=quadprog(H,f,[],[],[],[],lb,ub);       
        f=[ones(length(n),1);zeros(width*height,1)];
        Aineq=[-eye(length(n)),A;-eye(length(n)),-A];
        bineq=[n;-n];
        x=cplexmilp(f,Aineq,bineq,[],[],[],[],[],lb,ub,ctype0,[],options);
        x0=x(length(n)+1:width*height+length(n));
        xsol=cplexlsqnonnegmilp(A,n,[],[],[],[],[],[],[],ctype,[],options);
end 

recovery=reshape(xsol,height,width);
error=maxMatchEuclidean(recovery,cgt_all,width,height,pedestrain_nmb)
sum=countErr(width,height,density_all,cgt_all,recovery,pedestrain_nmb);

draw=recovery+cgt_all;
figure(2);
imagesc(cgt_all);
figure(3);
imagesc(recovery);
figure(4);
imagesc(draw);
