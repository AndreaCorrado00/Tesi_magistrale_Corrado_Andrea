% figure
clc
clear all
close all

load dataset.mat

fs = 2034.5; %Hz
Ts = 1/fs; % sec
timeVector = [0:Ts:1];

subj = '3';
record = '5';

%% Q1
figure, 
subplot(2,1,1)
plot(timeVector, data.MAP_A.(strcat('MAP_A',subj)).rov_trace.(strcat('Var',record)),'LineWidth',2)
title('Rov trace')
ylabel('mV')
grid on
set(gca,'FontSize',18,'FontWeight','bold')

subplot(2,1,2)
plot(timeVector, data.MAP_A.(strcat('MAP_A',subj)).ref_trace.(strcat('Var',record)),'LineWidth',2)
title('Ref trace')
ylabel('mV')
xlabel('Time [s]')
grid on
set(gca,'FontSize',18,'FontWeight','bold')

%% Q2
subj_tmp = {'2','4','6','10'};
figure, 
xline(0.5,'--k','LineWidth',3)
hold on,
for k = 1:length(subj_tmp)
    ax(k) = plot(timeVector, data.MAP_A.(strcat('MAP_A',subj_tmp{k})).ref_trace.(strcat('Var',record)),'LineWidth',2);
    
end
legend([ax(1),ax(2),ax(3),ax(4)], {'subj 2','subj 4','subj 6','subj 10'})

title('Ref trace')
ylabel('mV')
grid on
set(gca,'FontSize',18,'FontWeight','bold')


%% Q3
figure, 
subplot(3,1,1)
plot(timeVector, data.MAP_A.(strcat('MAP_A',subj)).rov_trace.(strcat('Var',record)),'LineWidth',2)
title('Rov trace')
ylabel('mV')
grid on
set(gca,'FontSize',18,'FontWeight','bold')

subplot(3,1,2)
plot(timeVector, data.MAP_A.(strcat('MAP_A',subj)).ref_trace.(strcat('Var',record)),'LineWidth',2)
title('Ref trace')
ylabel('mV')
grid on
set(gca,'FontSize',18,'FontWeight','bold')

subplot(3,1,3)
plot(timeVector, data.MAP_A.(strcat('MAP_A',subj)).spare1_trace.(strcat('Var',record)),'LineWidth',2)
title('Spare 1 trace')
ylabel('mV')
xlabel('Time [s]')
grid on
set(gca,'FontSize',18,'FontWeight','bold')
