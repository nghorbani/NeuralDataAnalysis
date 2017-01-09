function [best_a,best_MM]=modBUBfunc(N,m,k_max,display_flag,lambda_0);
%*******************************************************************************************************
%function [a,MM]=BUBfunc(N,m,k_max,display_flag,lambda_0)
%
%implements BUB entropy estimator described in Paninski, '03, Neural
%Computation, 'Estimation of entropy and mutual information'
%
%LP 5/1/02
%revised LP 10/20/02, as per revision in Paninski, `02
%revised LP and Masanao Yajima 8/14/06 to improve speed and accuracy:
%      revision avoids unnecessary computation of binomial P matrix (new code allows arbitrarily large N, assuming m is also large) 
%      and uses a log mesh for computation of the P
%      matrix for improved accuracy
%
% IN: m = number of bins;
%     N = number of samples;
%     k_max = a degree of freedom parameter; if k_max=1, the algorithm basically returns the Miller-Madow estimator; as k_max becomes larger, the algorithm returns the (original) BAGfunc estimator.  k_max ~ 10 is optimal for most applications  
%     display_flag = a flag to display some performance information
%     lambda_0 (optional) = Lagrange multiplier on a_0 (see paper for notation)
%
% OUT: a = coefficients for BUB estimator;
%      MM = upper bound on rms error in bits
%
% internal variables mesh, meshm, s, and sm should be adjusted as needed  
% to ensure the accurate computation of the maxima of B and V1, as required
% for the computation of MM (ie, the mesh should be fine enough, and the scale s should be wide enough)
%
%*******************************************************************************************************
% given a histogram n, type:
%
%m=length(n); N=sum(n); display_flag=1; k_max=11; %this value of k_max should be sufficient if N<10^6
%[a,MM]=BUBfunc(N,m,k_max,display_flag);
%BUB_est=sum(a(n+1));
%*******************************************************************************************************
%
%note: the code is optimized for small N/m ratios (eg, 0 < N/m < 100);
%    you might consider using a different mesh for the binomial P matrix if
%    your m and N are not in this range.  (alternately, the Miller-Madow
%    and jackknife estimators work well for N/m>100.)
%
%


% Parameter checking
if(nargin<5) lambda_0=0; end;

if(N<20)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Run BAGfunc
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    [best_a,best_MM]=BAGfunc(N,m,display_flag,lambda_0);
else
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Main Procedure
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if(k_max>N) disp('restricting k_max to be less than N...'); end
    c=80;      % constant number to restrict the binomial coefficients in the P matrix: values are effectively zero for larger N
    c=ceil(min(N,c*max(N/m,1)));
    s=30;
    mesh=200;
    eps=(N^-1)*10^-10;
    %Ni=gammaln(N+1)-gammaln(1:N+1)-gammaln(N+1-(0:N));
    Ni=gammaln(N+1)-gammaln(1:c+1)-gammaln(N+1-(0:c));

    %p=eps:min(1,s/N)/mesh:min(1,s/N)-eps;
    p=logspace(log10((1e-4)/N),log10(min(1,s/N)-eps),mesh); %logarithmic mesh makes L2 norm a better approximation of the max
    lp=log(p); 
    lq=log(1-p);
    %P=exp(repmat(Ni',1,length(p))+(0:N)'*lp+(N-(0:N))'*lq);
    P=exp(repmat(Ni',1,length(p))+(0:c)'*lp+(N-(0:c))'*lq);
    %P=exp(repmat(Ni(:,1:c)',1,length(p))+(0:c-1)'*lp+(N-(0:c-1))'*lq);
 
    epsm=(m^-1)*10^-10;
    sm=s;
    meshm=mesh;
    pm=epsm:min(1,sm/m)/meshm:min(1,sm/m)-epsm;
    lpm=log(pm); lqm=log(1-pm);
    
    %Pm=exp(repmat(Ni(:,1:c)',1,length(pm))+(0:c-1)'*lpm+(N-(0:c-1))'*lqm);
    Pm=exp(repmat(Ni',1,length(pm))+(0:c)'*lpm+(N-(0:c))'*lqm);
    %Pm2=exp(repmat(Ni',1,length(pm))+(0:N)'*lpm+(N-(0:N))'*lqm);
    f=zeros(size(pm));
    f(find(pm<=1/m))=m;
    ff=find(pm>1/m);
    f(ff)=pm(ff).^-1;
    
    a=(0:N)/N;
    a=-log(a.^a)+(1-a)*.5/N;
    a=a';
    mda=max(abs(diff(a)));
    
    best_MM=Inf;
    for(k=1:min(k_max,N))
        %h_mm=a(k+1:end)'*P(k+1:end,:);
        h_mm=a(k+1:c+1)'*P(k+1:end,:);
        XX=(m^2)*(P(1:k,:)*P(1:k,:)');
        XY=(m^2)*(P(1:k,:)*(-log(p.^p)-h_mm)');
        XY(k)=XY(k)+N*a(k);
        DD=2*eye(k)-diag(ones(1,k-1),1)-diag(ones(1,k-1),-1);
        DD(1)=1;
        DD(k,k)=1;
        AA=XX+N*DD;
        AA(1)=AA(1)+lambda_0;
        AA(k,k)=AA(k,k)+N;
        a(1:k)=pinv(AA)*XY;
        
        B=m*(a(1:c+1)'*P+log(p.^p));
        %B=m*(a'*P+log(p.^p));
        maxbias=max(abs(B));
        V1=(((0:c)/N)'.*((a(1:c+1)-[0;a(1:c)]).^2))'*Pm;
        mmda=max(mda,max(abs(diff(a(1:min(k+2,length(a)))))));
        MM=sqrt(maxbias^2+N*min(mmda^2,4*max(f.*V1)))/log(2);
        %disp(MM);
        
        if(MM<best_MM)
            best_MM=MM;
            best_a=a;
            best_B=B;
            best_V1=V1;
            disp(sprintf('current best k = %i; best max error = %2.3f',k,best_MM));
        end;
    end;
    if(0)
        %use a full optimization on the true upper bound, instead of the L2 approximation used above
        %...only gives slight improvements.
        opt_a=fminunc('BUBerrfunc',best_a(1:19),[],best_a(20:end),m,P,p,c,N,Pm,k,f,mda);
        best_a(1:19)=opt_a;
    end;
    
    best_B=m*(best_a(1:c+1)'*P+log(p.^p));
    maxbias=max(abs(best_B));
    V1=(((0:c)/N)'.*((best_a(1:c+1)-[0;best_a(1:c)]).^2))'*Pm;
    mmda=max(mda,max(abs(diff(best_a(1:min(k+2,length(best_a)))))));
    best_MM=sqrt(maxbias^2+N*min(mmda^2,4*max(f.*V1)))/log(2);
    
    if(display_flag)
        disp(sprintf('m=%i; N=%i; max mse<%2.4f bits; max bias<%2.4f',m,N,best_MM,max(abs(best_B))/log(2)));
        figure(88);
        subplot(2,1,1)
        plot(p,best_B/log(2)); axis tight; title('bias function'); xlabel('p')
        subplot(2,1,2);
        plot(pm,4*N*f.*best_V1); axis tight; title('variance (Steele) function'); xlabel('pm')
    end;
end



function [a,MM]=BAGfunc(N,m,display_flag,lambda_0,lambda_N);
%*******************************************************************************************************
%function [a,MM]=BAGfunc(N,m,display_flag,lambda_0,lambda_N)
%
% IN: m = number of bins;
%     N = number of samples;
%     k_max = a degree of freedom parameter; if k_max=1, the algorithm basically returns the Miller-Madow estimator; as k_max becomes larger, the algorithm returns the (original) BAGfunc estimator.  k_max ~ 10 is optimal for most applications
%     display_flag = a flag to display some performance information
%     lambda_0 (optional) = Lagrange multiplier on a_0 (see paper for notation)
%
% OUT: a = coefficients for BUB estimator;
%      MM = upper bound on rms error in bits
%
%*******************************************************************************************************

if(nargin<5) lambda_N=0; end;
if(nargin<4) lambda_0=0; end;

fa=gammaln(1:2*N+1); %use gammaln instead of factorial for accuracy, speed
Ni=fa(N+1)-fa(1:N+1)-fliplr(fa(1:N+1));

%p=.5*(1+cos(pi*(0:(N*2))/(N*2))); %p is a mesh for integration; this specific mesh comes from Tchebysheff approximation, but others can be used
%p=fliplr(p(2:end-1));
p=(0:N*5)/(N*5);
p=p(2:end-1);
lp=log(p); lq=fliplr(lp);
P=zeros(N+1,length(p)+2);
for(i=0:N) %build matrix of Bernoulli polynomials
    P(i+1,2:end-1)=Ni(i+1)+(i*lp+(N-i)*lq);
end;
P=exp(P);
P(2:end-1,[1 end])=zeros(N-1,2);
P(1,1)=1;
P(end,end)=1;
P(end,1)=0;
P(1,end)=0;
p=[0 p 1];
f=zeros(size(p));
ff=find(p<=1/m);
f(ff)=m;
ff=find(p>1/m);
f(ff)=p(ff).^-1; %f is the weighting function, as in the paper

%X=(P.*repmat(f,N+1,1))';
X=m*P';

XX=X'*X; %self-products of integrals (sums, here)
%XY=X'*(f.*(-log(p.^p)))'; %cross-products
XY=m*X'*(-log(p.^p))';

DD=2*eye(N+1)-diag(ones(1,N),1)-diag(ones(1,N),-1);
DD(1)=1;
DD(N+1,N+1)=1;

%lambda_0=0; %these are Lagrange multipliers that can be adjusted to keep the value of H_BUB
%lambda_N=0; %small at "zero entropy" points (where H_MLE is small).  See paper for details

%AA=XX+N*DD/4;
AA=XX+N*DD;
AA=AA.*(abs(AA)>max(max(abs(AA)))*10^-7);
%figure(99); imagesc(log(AA)); colorbar; %rank(AA)
AA(1)=AA(1)+lambda_0;
AA(N+1,N+1)=AA(N+1,N+1)+lambda_N;
%AA=sparse(AA);
%figure(54); imagesc(log(AA)); colorbar

if(0)
    [u,d,v]=svd(AA);
    figure(66); plot(log(diag(d))); %plot log spectrum; AA starts getting singular (according to matlab default eps values) around N=500 if N/m < .5
    svs=0; %inverse by svd; set svs=j to throw out j svds
    i=N+1-svs;
    invd=zeros(size(d));
    invd(1+(0:i-1)*(N+2))=d(1+(0:i-1)*(N+2)).^-1;
    a=v*invd*u'*XY;
else
    %disp('inverting...')
    a=pinv(AA)*XY; %or just use inv() instead
end;

%mm=-log(((0:N)/N).^((0:N)/N))+(1-(0:N)/N)/(2*N);
%khg=ceil(length(a)*.01):length(a);
%khg=4:length(a);
%a(khg)=mm(khg);

MM=[];
mesh=10;
%p=.5*(1+cos(pi*(0:mesh*(N+1))/(mesh*(N+1)))); %use a finer mesh to compute the sup norm accurately
%p=fliplr(p(2:end-1));
%p=unique([(0:N*mesh)/(N*mesh) .5*(1+cos(pi*(0:mesh*(N+1))/(mesh*(N+1))))]);
p=(0:N*mesh)/(N*mesh);
p=p(2:end-1);
lp=log(p); lq=fliplr(lp);
P=zeros(N+1,length(p)+2);
for(i=0:N)
    P(i+1,2:end-1)=Ni(i+1)+(i*lp+(N-i)*lq);
end;
%P=repmat(Ni',1,length(p))+(0:N)'*lp+(N-(0:N))'*lq;
P=exp(P);
P(2:end-1,[1 end])=zeros(N-1,2);
P(1,1)=1;
P(end,end)=1;
P(end,1)=0;
P(1,end)=0;
p=[0 p 1];
f=zeros(size(p));
ff=find(p<=1/m);
f(ff)=m;
ff=find(p>1/m);
f(ff)=p(ff).^-1;

Pn=a'*P;
%maxbias=2*max(f.*abs(Pn+log(p.^p)));
maxbias=m*max(abs(Pn+log(p.^p)));

figure(22); plot(p,Pn+log(p.^p));

MM=sqrt(maxbias^2+N*(max(abs(diff(a))))^2)/log(2);
if(display_flag)
    disp(sprintf('m=%i; N=%i; max mse<%f bits',m,N,MM));

    %%plot (computed BUB coefficients) - (MLE coefficients)
    %figure(1); plot(a'+log(((0:N)/N).^((0:N)/N)),'b'); axis tight
    %hold on; plot(zeros(1,N+1),'r'); hold off
    %xlabel('N'); ylabel('a_{BUB} - a_{mle}'); title('BUB-MLE')
end;



function MM=BUBerrfunc(a1,a2,m,P,p,c,N,Pm,k,f,mda);

a=[a1;a2];
B=m*(a(1:c+1)'*P+log(p.^p));
maxbias=max(abs(B));
V1=(((0:c)/N)'.*((a(1:c+1)-[0;a(1:c)]).^2))'*Pm;
mmda=max(mda,max(abs(diff(a(1:min(k+2,length(a)))))));
MM=sqrt(maxbias^2+N*min(mmda^2,4*max(f.*V1)))/log(2);

return;
