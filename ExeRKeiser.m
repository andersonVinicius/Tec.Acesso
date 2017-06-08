clear all; close all;clc;
%Exerc 11.8 
connctLoss = 0.0;
a = 0.4;%attenuation in dB/km
l = 10+[5 4 3 2]+0.2;%link length KM
sysMargin = 3;%system margin can be selected to be around 3 dB
n_spliceLoss = 6;
spliceLoss = 0.1;
WDM_coupler_losses = 0.0;
splitter_1X8 = 10.7%db
splitter_1X4 = 7.7%db
cab_loss = a * l 
lossTot = cab_loss + (n_spliceLoss*spliceLoss) + splitter_1X8+splitter_1X4;%dB

%Exerc 11.3 
splitter_1X16 = 13.5%dB
n_connct = 5;
n_splice = 4;
connct_and_spliceLoss = 0.1;
%Consider the 1310-nm
WDM_coupler_losses = 1.5;
sysMargin = 3;%system margin can be selected to be around 3 dB
lb = 20%link length KM
a = 0.4;%attenuation in dB/km 
cab_loss11_3 = a*lb
POWER_Tot11_3 = cab_loss11_3+( (n_connct+n_splice) * connct_and_spliceLoss)+ splitter_1X16+WDM_coupler_losses + sysMargin;%dB

%Exerc 11.1 
DCD = 4.0*10^-3%chromatic dispersion
L = 20%KM
B = 2.5%Gbps
Y = 0.1%nanometers

PCD = -5*log10(1 -(4*B*L*DCD*Y)^2)
%Exerc 9.7 pesquisa 
%Exerc 9.3 ?????




