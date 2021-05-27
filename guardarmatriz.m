%   Mat Troncoso Villar (matro1432@gmail.com)
%   Creada en 2020. Actualmente prefiero el método con datenum y datestr
archivo='iglobal_copernicus_sla.dat';
fileA = importdata(archivo,' ',42);
[fileA] = fileA.data;
[year] = fileA(:,1);
dataqtt = ones(length(year).*12,4);
for i=[1:length(year).*12]
  k = fix(i/12.00001)+1; %creo un valor auxiliar para repetir el año 12 veces, + ceros porque o sino luego genera problemas
  dataqtt(i,1)= year(k,1); %le chanto el año a la matriz que será mi fecha
  dataqtt(i,2)= i-(12*(k-1)); %en la segunda columna pongo el mes, aquí daba problema 12.1 y 12.01. Puse + ceros
endfor
for i=[1:27] %para cada año
  for u=[1:12] %para cada mes
    j=(12*(i-1))+u; %creo un auxiliar que determina un número sucesivo
    dataqtt(j,4)= fileA(i,1+u); %pongo el dato correspondiente del archivo original en esta sola columna de la nueva matriz
  endfor
endfor
fecha = datenum(dataqtt(:,1:3));
fileb = [fecha,dataqtt(:,4)];
[errores]= find(fileb(:,2)==-999.9);
fileb(errores,2)= NaN;


save fileb.dat fileb
