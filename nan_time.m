%Función para graficar NaN respecto a la fecha
 %
%Argumentos de entrada:
    %fechas: vector de fechas incompletas (si falta un día = NaN)
%Argumentos de salida:
    %S: -.
% Por José_G.V (jguevara2018@udec.cl)
% Hecho función: 2022-05-15 - Mat Troncoso Villar (matro1432@gmail.com)

function S = nan_time(fechas)
fechascreadas=datenum(fechas(1):fechas(end));
Datoslistos=fechascreadas';
Datoslistos(:,2)= NaN(length(Datoslistos),1);
fechasmalas=[];

for i = fechascreadas
    finding=find(i == fechas(:,1));
     if length(finding) == 1
         Datoslistos(finding,2)=fechas(finding,1);
     end
    if length(finding) ~= 1
       fechasmalas=[fechasmalas i];
    end
end
fechasmalas=fechasmalas';

plot(fechasmalas,'o','LineWidth',3)
datetick('y','yyyy','keepticks')
grid on
set(gca,'FontSize',20)
xlabel('Datos faltantes')
title('Datos faltantes vs tiempo','FontSize',20)
ylabel('Fecha')
end