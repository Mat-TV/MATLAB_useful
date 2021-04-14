domx=linspace(0,10,15); %el dominio donde graficar X
domy=domx; %el dominio donde graficar Y
[x, y]=meshgrid(domx,domy); %para crear equises e ys que rellenar
k=5;  %k y U son constantes para el ejemplo nada más.
U=1;
%%
z=y-(cos(k*x)/k); %z es la constante a la que se igualan las líneas de corriente
u=-U.*ones(15,15); %valores del campo en u
v=U.*sin(k*x); %valores del campo en v
hold on
contour(x,y,z, 1) %graficar las curvas de nivel
quiver(x,y,u,v,1.5); %pasarle las cosas a quiver para graficar
hold off