%Criado em 21/05/2017 %}
%Codigo que calcula taxa de tranferencia de um cabo DSL com varia secçoes
%Bitola:[0.4 0.5 0.63 0.90]
%diferentes ou não
%Colaboradores: Edemir e Thiago v1
%               Rafael          v2
%               Vitoria         v3
%               Anderson        v4

function[gama, z0] = calcula_cabo2(u,f)

%Dados gerais
w = 2 * pi * f; % frequencia angular
sigma = 5.8 * 10^7;  %Condutividade - S/m
m0= 1.2566*(10^(-6)); % permeabilidade magnetica do vacuo H/m (ou TÂ·m/A).
epson0 = 8.85418782*10^-12; % Permissividade eletrica do vacuo.
%-------------------------------------------------------------------------


% Valores por tipo-cabo
s = [0.3 0.19 0.31 0.41]/1000 %Espessura do Isolante
d = [0.4 0.51 0.64 0.96]/1000; %Diametro do condutor
v = [100 100 100 100];
epsonM = [2.115 2.115 2.197 2.115]; 
epsonS = [2.3 2.3 2.2 2.3]; 
t = [2*10^(-20) 2*10^(-20) 6*10^(-4) 2*10^(-20)];
a = [0.87 0.87 0.53 0.87];
b = [0.25 0.25 0.14 0.25];


%calculo do da secção
r = 1 + (2 * s(u) / d(u));
r0 = 4 / (pi * sigma * ( d(u) ^ 2 )); 
wb = (1i* w * m0 / pi);
nb = 1 + (1 /(24 * (r ^ 2) - 2)); % Valores assinóticos de n para baixas frequências
na = (4 * (r ^ 2) - 1) * (log(2*r) - acosh(r)) ; % Valores assinóticos de n para altas frequências
n = na - ((na - nb)./(sqrt(1 + ((1/9) * (1 - (1 / (r ^ 2)))) * (wb / r0)))); %Fator multiplicativo que corrige o erro ao aproximar a impedância devido ao efeito de proximidade considerando apenas um termo.

x = (1i * w * pi * epson0) / acosh(r);
z = (1 - (1/(9*(r^(1/10)-(19/24)))));
yp = x .*  (epsonM(u) + ((epsonS(u) - epsonM(u))./ ((1 + ((1i*w*t(u)).^(1-a(u))).^b(u))).^z)); %Admitância paralelo de um par-trançado sem o efeito do trançado.

x1 = sqrt(-wb*r0).*( besselj(0,(sqrt(-wb/r0))) )./( besselj(1,(sqrt(-wb/r0))) );
z1 = wb.*( log(2*r) + (n./ (1+4*r^(2).* (besselj(0,(sqrt(-wb/r0)))./besselj(2,(sqrt(-wb/r0)))))));
zs = x1 + z1; %Impedância série de um par-trançado sem o efeito do trançado 

z0 = sqrt(zs./yp); %Impedância caracteristica em funcao da frequencia
gama = sqrt(zs .* yp .* (1+(pi*v(u)*r*d(u))^2) ); %


end
