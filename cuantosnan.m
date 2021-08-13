% English description at the bottom
%Función para contar los NaN de los datos
 %
%Argumentos de entrada:
    %archivo: Datos, ya sean vectores o columnas
%Argumentos de salida:
    %S: cantidad de NaNs
%  2021-06-01 - Mat Troncoso Villar (matro1432@gmail.com)
function S = cuantosnan(archivo)
  losNaN=isnan(archivo);
  S=sum(sum(losNaN));
end