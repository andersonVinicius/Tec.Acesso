
%Criado em 21/05/2017 %}
%Codigo principal que calcula taxa de tranferencia de um cabo DSL com varia secçoes
%Bitola:[0.4 0.5 0.63 0.90]
%diferentes ou não
%Colaboradores: Edemir e Thiago v1
%               Rafael          v2
%               Vitoria         v3
%               Anderson        v4

clear all; close all;clc;


f = 0: 1e3 :1e7;
cable = [0.4]; %Bitolas utilizadas
l = [2.2]; %comprimento das seccoes

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

[gama, z0] = calcula_cabo2(u,f);%chamar função

A(:,i) = cosh(gama*l(i));
B(:,i) = z0.*sinh(gama*l(i));
C(:,i) = (1./z0).*sinh(gama*l(i));
D(:,i) = cosh(gama*l(i));    


end % for - line 25
%--------------------------------------------------------------------------
for i = 1: n_sections
   
   for freq = 1:size(f,2)
       T(:,:,freq,i) = [A(freq,1) B(freq,1); C(freq,1) D(freq,1)];  
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

H = 100./(100.*(ATotal+BTotal)); %Função Tranferência

figure
plot(f,real(z0));
grid on;
title('real z0');

figure
grid on;
plot(f,imag(z0));
grid on;
title('imaginario z0');

figure
plot(f, real(gama)) ;
grid on;
title('real gamma');


figure
plot(f , imag(gama) );
grid on;
title('imaginario gamma');

figure
plot(f , 20*log10( abs (H) ));
grid on;
title(' Potencia em db ');
ylabel('H(f)^2');
xlabel('f');

