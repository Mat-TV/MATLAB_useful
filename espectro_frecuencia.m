%% método de pwelch (antes: spectrum) 
% script original por René Garreaud, modificado por Martín Jacques (mjacques@dgeo.udec.cl)
% ***cálculo del espectro de frecuencia II (usando spectrum... deprecated: ahora pwelch!)
% ***pasos 1. (detrend) y 2. (ciclo anual)
% ***paso 3.: la serie de tiempo esta en el vector xp (largo par)
%Argumentos de entrada:
    %serie: serie de tiempo a analizar
    %tiempos: escala de tiempos de "serie". 'y' para años; 'd' para días
    %figura: ¿quieres la figura? ['y'/'n']
%Argumentos de salida:
    %Tk: periodo
    %Px: poder espectral
    %s: media
    %interv_inf: intervalo de confianza inferior
    %interv_sup: intervalo de confianza superior
    %Tk_max: máximo del periodo en [tiempos]
function [Tk,Px,s,interv_inf,interv_sup,Tk_max] = espectro_frecuencia(serie,tiempos)%,figura)
%%
for jk = 1:length(serie(:,1))

% clear all
% close all
% fecha=220512

%% 1. serie original sin tendencia! 
% ***serie de prueba: anomalías intraestacionales de temperatura media para el SE de Patagonia, DEF 1983/84
% load('./Tm_IS_SEPG_1984.mat','Tm_IS_SEPG_1984')%archivo que acompaña a este script
% x_orig=Tm_IS_SEPG_1984;
x_orig=serie(jk,:);
x_dt=detrend(x_orig);
x=x_dt;
t=1:length(x);

% figure(10)
% clf
% hold on
% plot(t,x,'linewidth',2)
% plot(t,zeros(length(t)),'k--')
% title('Anomalías sin tendencia de la señal')
% set(gca,'fontsize',14)
%% 2. extraer ciclo anual (supuesto: frecuencia de sampleo es diaria)
% can=[sin(2*pi*t/365.25)' cos(2*pi*t/365.25)' ones(length(x),1)];
% ctes=regress(x,can);
% x_sca=x-can*ctes;
% x=x_sca;

%% 3. preparar la fft
xp=x;

n=length(xp);               % largo de la serie
s2=var(xp);                 % varianza de la serie 
cc=corrcoef(xp(1:n-1),xp(2:n)); 
r1=cc(1,2);                 % coef. autocorrelacion orden 1 ([phi] en el Wilks)

% parámetros importantes del analisis
nfft=2^nextpow2(n);    % largo de los fft individuales (tiene que ser del tipo 2^m m=1,2,.....)
%nfft=n                     % alternativa para probar sensibilidad: usar largo de la serie
%nfft=floor(n/2)+1;         % alternativa para probar sensibilidad: nfft de largo PAR cercano a n/2
over=nfft/2;                % traslape entre ventanas (usualmente nfft/2)

k=1:nfft/2;                 % "núm. de ondas"
Tk=nfft./k;                 % periodos
f=k/nfft;                   % frecuencias

%% 4. aplicar fft para calcular el espectro mediante el método de welch
% la función pwelch reemplaza a "spectrum" (deprecated) de versiones más antiguas de matlab

%%alternativa: uso de ventana rectangular
%[PPX,fwelch]=pwelch(xp,[],over,nfft,'psd',1); 
%%alternativa: uso de ventana "hamming" de largo n
[PPX,fwelch]=pwelch(xp,hamming(n),over,nfft,'psd',1); 

Px=(1/nfft)*PPX(2:nfft/2+1);% primeros nfft/2 armonicos (sin la cte), normalizados por nfft 
%nota: en "spectrum" se realizaba una normalización por nfft/2; efectivamente hay un factor 2/fs entre las funciones "pwelch" y la antigua "psd/spectrum":
%https://www.mathworks.com/matlabcentral/answers/18617-pwelch-vs-psd)
sum(Px)

%% 5. comprobar: el espectro representa la varianza? de dónde proviene la diferencia? (discretización... algo más?)
% En este caso, deberíamos tener sum(Px)~var(xp); sin embargo, hay una
% sobreestimación de la varianza
% en el caso de nfft=2^nextpow2(n); sum(Px)-s2 ~ 8.7218-7.0154~0.94 (sobreestimación del 24%!) 

%% 6. calcular espectro de ruido rojo

% wilks (2006), ecs. 8.21 & 8.77 (p. 355 & 391, resp.) // wilks (2011), ecs. 9.21 & 9.77 & (p. 413 & 447, resp.)
% von storch & zwiers (2003), ec. 11.23 (p. 223)

clear s_aux
wnvar=(1-r1^2)*(var(xp));% white noise variance [(sigma_epsilon)^2]
for i=1:nfft/2
    %red noise spectrum
% 	s_aux(i)=(1/4)*(4/nfft)*wnvar/(1+r1^2-2*r1*cos(2*pi*f(i))); % hay un factor 4/n de diferencia entre las dos fuentes citadas - explicación pendiente; antes se usaba nfft/2
	s_aux(i)=(1/2)*(4/nfft)*wnvar/(1+r1^2-2*r1*cos(2*pi*f(i))); % le quité el factor porque el ajuste es mejor
    
end

s=s_aux;

% el espectro de RR tiene el siguiente intervalo de confianza (ver 8.79-8.81 de wilks [2006])
    nu=ceil(2*n/nfft);   	% Grados de libertad ~ 2
    low=chi2inv(0.05,nu); 	% limite inferior de espectro RR
    high=chi2inv(0.95,nu); 	% limite superior de espectro RR
% if sum(Px>s*high/nu)==0
%     
% else
%     nu=ceil(2*n/nfft);   	% Grados de libertad ~ 2
%     low=chi2inv(0.025,nu); 	% limite inferior de espectro RR
%     high=chi2inv(0.975,nu); 	% limite superior de espectro RR
% end
%%
if tiempos == 'y'
    etiq = [2 3 4 5 6 7 8 9 10 15 20 30 40 50 100];
    etiq_periodo = 'años';
elseif tiempos == 'd'
    etiq = [2 3 4 5 6 7 8 9 10 15 20 30 40 50 60 70 80 90];
    etiq_periodo = 'días';
end
interv_sup = s*high/nu;
interv_inf = s*low/nu;
Tk_max=Tk(find(Px==max(Px)))%peak espectral: 25.6 días
Px_max=1.1*max(Px)%1.5;%
%
    Tk_cuent(jk,:) = Tk;
    Px_cuent(jk,:) = Px;
    s_cuent(jk,:) = s;
    interv_inf_cuent(jk,:) = interv_inf;
    interv_sup_cuent(jk,:) = interv_sup;
    Tk_max_cuent(jk,1) = Tk_max;
    nfft_cuent(jk,:) = nfft;
    Px_max_cuent(jk,1) = Px_max;
    r1_cuent(jk,1) = r1; 
%
end
%%% opcional: se puede comparar con la función periodograma
%[PPX3,f3]=periodogram(xp,hamming(n),nfft,1)
%plot(1./f3(2:nfft/2+1),(1/nfft)*abs(PPX3(2:nfft/2+1)),'r--','linewidth',2)
%%nota:
%el output de fft en matlab está normalizado por 2/L; 1/L corresponde a frecuencias positivas y 1/L a frecuencias negativas
%https://www.mathworks.com/matlabcentral/answers/232008-how-do-i-interpret-power-density-fft-plot-of-a-temperature-time-series
%sin embargo, periodogram puede entregar el one-sided periodogram en función de los parámetros de entrada; en tal caso, no es necesario multiplicarlo x2
% https://www.mathworks.com/help/signal/ref/periodogram.html#btt5n5n
%como complemento, esta discusión es relevante:
%https://www.mathworks.com/matlabcentral/answers/356376-can-someone-explaing-the-computation-for-double-sided-and-single-sided-spectrum-in-fft-example
%% para imprimir figura...

% figure(9111)
% 
%     name_fig=['./example_fourier_spectrum_1984_9111_' num2str(fecha)];
%     %print(name_fig,'-dpng','-r600')
%     %print(name_fig,'-depsc2')
%     
%     export_fig(name_fig,'-eps','-nocrop','-transparent')
%     export_fig(name_fig,'-png','-nocrop','-transparent')

    Tk = mean(Tk_cuent,1);
    Px = mean(Px_cuent,1);
    s = mean(s_cuent,1);
    interv_inf = mean(interv_inf_cuent,1);
    interv_sup = mean(interv_sup_cuent,1);
%     Tk_max = mean(Tk_max_cuent,1);
    nfft = mean(nfft,1);
%     Px_max = mean(Px_max,1);
    r1 = mean(r1,1);
%
Tk_max=Tk(find(Px==max(Px)));%peak espectral: 25.6 días
Px_max=1.1*max(Px);
% if figura == 'n'
    
% else
figure
clf


hold on
semilogx(Tk,Px,'b','linewidth',2) %serie
semilogx(Tk,s,'k--','linewidth',2) % med 
semilogx(Tk,interv_inf,'m--','linewidth',2) %interv. inferior
semilogx(Tk,interv_sup,'m--','linewidth',2) %interv superior
axis([2 nfft 0 Px_max])
set(gca,'xscale','log')
grid minor
set(gca,'fontname','arial','fontsize',14,'fontweight','bold')
set(gca,'xtick',etiq,'xticklabel',etiq)
xlabel("periodo [" + etiq_periodo + "]"); ylabel('poder espectral [°C^2]')
text(2.5,0.85*Px_max,['r1=' sprintf('%6.2f',r1)],'fontname','arial','fontsize',18,'fontweight','bold')
% title('SEPG: 20CR SAT'' / DJF 1984')

grid on

text(6,0.85*Px_max,['peak:' sprintf('%6.1f',Tk_max)],'fontname','arial','fontsize',18,'fontweight','bold')
% end
end
%%