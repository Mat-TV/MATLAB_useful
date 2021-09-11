%Función para limpiar el entorno de trabajo
 % a pedido de @Fetiki
%Argumentos de entrada:
    %nada: nada
%Argumentos de salida:
    %S: nada
%  2021-08-13 - Mat Troncoso Villar (matro1432@gmail.com)
function S = aseo(nada)
  close all;
  evalin('base','clear');
  clc;
end
