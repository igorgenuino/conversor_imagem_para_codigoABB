function [Px,Py] = bezier(p0x,p0y,cp0x,cp0y,cp1x,cp1y,p1x,p1y,N)
% N=10;
% % Exemplo 
% p0x=0;
% p0y=0;
% 
% cp0x=25;
% cp0y=100;
% 
% cp1x=75;
% cp1y=100;
% 
% p1x=100;
% p1y=0;

for i = 1:N
    t=i/N;
    
    %%
    Ax(i) = ( (1 - t) * p0x ) + (t * cp0x);
    Ay(i) = ( (1 - t) * p0y ) + (t * cp0y);
    Bx(i) = ( (1 - t) * cp0x ) + (t * cp1x);
    By(i) = ( (1 - t) * cp0y ) + (t * cp1y);
    Cx(i) = ( (1 - t) * cp1x ) + (t * p1x);
    Cy(i)= ( (1 - t) * cp1y ) + (t * p1y);
    %%
    Dx(i) = ( (1 - t) * Ax(i) ) + (t * Bx(i));
    Dy(i) = ( (1 - t) * Ay(i) ) + (t * By(i));
    
    Ex(i) = ( (1 - t) * Bx(i) ) + (t * Cx(i));
    Ey(i) = ( (1 - t) * By(i) ) + (t * Cy(i));
    %%
    Px(i) = ( (1 - t) * Dx (i)) + (t * Ex(i));
    Py(i) = ( (1 - t) * Dy (i)) + (t * Ey(i));
end

%exemplo
figure(1)
plot(Px,Py)
hold on
plot(p0x, p0y,'or') 
plot(cp0x, cp0y,'or') 
plot(cp1x, cp1y,'or') 
plot(p1x, p1y,'or')
