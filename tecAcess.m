
%Criado em 21/05/2017 %}
%Codigo principal que calcula taxa de tranferencia de um cabo DSL com varia sec�oes
%Bitola:[0.4 0.5 0.63 0.90]
%diferentes ou n�o
%Colaboradores: Edemir e Thiago v1
%               Rafael          v2
%               Vitoria         v3
%               Anderson        v4
%               Bruno Lyra      v5

clear all; close all;clc;


f = 4000:4300:1100000;
%f = (eps:10e3:1e9);


%f = linspace(1e3, 1e9, 1000);
cable = [0.4 0.63]; %Bitolas utilizadas
l = [1.3 5.7]*1000; %comprimento das seccoes

n_sections = size(cable,2); %carrega o numero de seccoes
%--------------------------------------------------------------------------
for i = 1:n_sections %Series impedance and shunt admitance

if cable(i) == 0.4 %Controle dos valores dos cabos.
    u = 1;
elseif cable (i) == 0.5
    u = 2; 
elseif cable (i) == 0.63
    u = 3;
elseif cable(i) == 0.9
    u = 4;
else
    error(['Cabo nao encontrado ','section ', num2str(i)]);
end % if - line 27

[gama, z0] = calcula_cabo2(u,f);%chamar fun��o

figure(1);
hold on
plot(f/1e6, real(z0));


A(:,i) = cosh(gama*l(i));
B(:,i) = z0.*sinh(gama*l(i));
C(:,i) = (1./z0).*sinh(gama*l(i));
D(:,i) = cosh(gama*l(i));    


end % for - line 25
%--------------------------------------------------------------------------
for i = 1: n_sections
   
   for freq = 1:size(f,2)
       T(:,:,freq,i) = [A(freq,i) B(freq,i); C(freq,i) D(freq,i)];  
   end
   
   if i == 1
       Total = T(:,:,:,i);
   else
       Total = Total.*T(:,:,:,i);
   end
   
end
%--------------------------------------------------------------------------

ATotal = reshape(Total(1,1,:),[1,size(f,2)]);
BTotal = reshape(Total(1,2,:),[1,size(f,2)]);
CTotal = reshape(Total(2,1,:),[1,size(f,2)]);
DTotal = reshape(Total(2,2,:),[1,size(f,2)]);

T = 100./(ATotal*100+BTotal); %Fun��o Tranfer�ncia
Zi = (ATotal*100+BTotal)/(CTotal*100+DTotal);
H = (Zi/(Zi+100))*T;
% figure
% plot(f,real(z0));
% grid on;
% title('real z0');

% figure
% grid on;
% plot(f,imag(z0));
% grid on;
% title('imaginario z0');
% 
% figure
% plot(f, real(gama)) ;
% grid on;
% title('real gamma');


% figure
% plot(f , imag(gama) );
% grid on;
% title('imaginario gamma');

figure
plot(f/1e6 , 20*log10(abs(H)));
grid on;
title(' H(f) ');
ylabel('Magnitude');
xlabel('MHz');

%%
%Calculo da capacidade do enlace projetado;
% C = W*log2(1+(abs(H).^2)*PSD);

W = 4300;
PSD = -40; %PSD de entrada dada em dBm/Hz;
%10*log10(x)= PSD
x = ((10^(PSD/10))/1000)*length(f)*W;
rx = (abs(H).^2)*x; % em watts
N_dbm = -140; % PSD do ruido -100 dBm/Hz
N = (10^(N_dbm/10))/1000;
C = 6*W*real(log2(1+rx/N));
% 
TaxaReal = sum(C)/1e6

    %% Questao 3

    l1 = 500;
    l2 =500;
    l3 = 1500;
    c = 0.67*3e8;


    %V = VarEspaco/VarTempo;

    Ta = (2*l1)/c;
    Tb = 2*(l1+l2)/c;
    Tc = 2*(l1+l3)/c;
