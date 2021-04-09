% English description at the bottom
%%Función para invertir una matriz rectangular que está en años x meses a
 %una matriz de una columna con fecha y otra con datos
 %
%Argumentos de entrada:
    %archivo: Matriz de 13 columnas, la primera debe ser el año, la segunda enero, la tercera febrero...
%Argumentos de salida:
    %S: matriz de 2 columnas, la primera es la fecha en formato datenum y la segunda el dato.
%  2021-04-09 - Mat Troncoso Villar (matro1432@gmail.com)
function S = reordigi(archivo)
    jaroj=archivo(:,1);
    datumoj = ones(length(jaroj).*12,4);
    for i=[1:length(jaroj).*12];
      k = fix(i/12.00000001)+1; %creo un valor auxiliar para repetir el año 12 veces, + ceros porque o sino luego genera problemas
      datumoj(i,1)= jaroj(k,1); %le pongo el año a la matriz que será mi fecha
      datumoj(i,2)= i-(12*(k-1)); %en la segunda columna pongo el mes %aquí daba problema 12.1 y 12.01 de la sexta fila. Puse + ceros
      datumoj(i,3)= 15; %aquí pongo el día del mes en que quiero fijar el dato de cada mes
    end
    for i=[1:length(jaroj)]; %para cada año
     for u=[1:12]; %para cada mes
       j=(12*(i-1))+u; %creo un auxiliar que determina un número sucesivo
       datumoj(j,4)= archivo(i,1+u); %pongo el dato correspondiente del archivo original en esta sola columna de la nueva matriz
     end
    end
    S = [datenum(datumoj(:,1:3)) datumoj(:,4)];
end
%%Function to transform a year x months rectangular matrix
 %to a date|data matrix
 %
%Inputs:
    %archivo: 13 column matrix, first one of them is the year, second is
    %January, third is February, ...
%Outputs:
    %S: 2 column matrix, first one's datenum format date and second one's
    %the data