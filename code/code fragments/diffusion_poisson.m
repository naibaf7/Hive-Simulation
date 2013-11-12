function [P,it] = diffusion_poisson(S, tol, maxit)
    
    [~,N] = size(S);
    n = N^2;
    A = gallery('poisson', N);
    b = reshape(S,n,1);
    
    %it = 0;
    %D = diag(A);
    %Dinv = D.^-1;
    %x = zeros(n,1);
    %r = b-A*x;
    %while( it < maxit && norm(r,2) > tol*norm(b,2))
    %    x = x + Dinv.*r;
    %    r = b-A*x;
    %    it = it + 1;
    %end
    [x,~,~,it] = pcg(A,b,tol,maxit);

    P = reshape(x,N,N);
end

