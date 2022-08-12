% compute the faciliation percent at 5 probabilities; similar to "F_percent_MP_master"
% call function "F_percent_IE.m" which will also call "LIFmodel_IE.m" 
% reduce the shuffle number (Line8) will speed up the program
% by CCG @ 2021-12-07

clear; clc

N = 200 ; %shuffle number; 200 is used in the paper
spike_num_Poi = 36 ; % Number of Possion spikes
noise_magnitude = 2.5e-8; %default noise level in conductance--decide spontaneous firing rate

num_random = 20 ;
num_repeat = 300 ;
num_decay = 100 ; % Unlike MP model, this value is estimated from curves; firing rate is stable after this value
rate_range = (num_random+num_decay+1) : (num_random+num_repeat) ; 

load('I_prob_100_tau10s.mat')
prob_100_Ex = p_All_Ex ;
prob_100_In = p_All_In ;
prob_100_percent = nan(N, 1);
prob_100_percent_L = nan(N, 1);
prob_100_rate = nan(N, 1);
for n = 1 : N
    [prob_100_percent(n), prob_100_percent_L(n), prob_100_rate(n)] = F_percent_IE(num_random, num_repeat, prob_100_Ex, prob_100_In, spike_num_Poi, noise_magnitude, rate_range, num_decay);
end

load('I_prob_75_tau10s.mat')
prob_75_Ex = p_All_Ex ;
prob_75_In = p_All_In ;

prob_75_percent = nan(N, 1);
prob_75_percent_L = nan(N, 1);
prob_75_rate = nan(N, 1);
for n = 1 : N
    [prob_75_percent(n), prob_75_percent_L(n), prob_75_rate(n)] = F_percent_IE(num_random, num_repeat, prob_75_Ex, prob_75_In, spike_num_Poi, noise_magnitude, rate_range, num_decay);
end

load('I_prob_50_tau10s.mat')
prob_50_Ex = p_All_Ex ;
prob_50_In = p_All_In ;
prob_50_percent = nan(N, 1);
prob_50_percent_L = nan(N, 1);
prob_50_rate = nan(N, 1);
for n = 1 : N
    [prob_50_percent(n), prob_50_percent_L(n), prob_50_rate(n)] = F_percent_IE(num_random, num_repeat, prob_50_Ex, prob_50_In, spike_num_Poi, noise_magnitude, rate_range, num_decay);
end
%
load('I_prob_25_tau10s.mat')
prob_25_Ex = p_All_Ex ;
prob_25_In = p_All_In ;
prob_25_percent = nan(N, 1);
prob_25_percent_L = nan(N, 1);
prob_25_rate = nan(N, 1);
for n = 1 : N
    [prob_25_percent(n), prob_25_percent_L(n), prob_25_rate(n)] = F_percent_IE(num_random, num_repeat, prob_25_Ex, prob_25_In, spike_num_Poi, noise_magnitude, rate_range, num_decay);
end

load('I_prob_7_tau10s.mat')
prob_7_Ex = p_All_Ex ;
prob_7_In = p_All_In ;
prob_7_percent = nan(N, 1);
prob_7_percent_L = nan(N, 1);
prob_7_rate = nan(N, 1);
for n = 1 : N
    [prob_7_percent(n), prob_7_percent_L(n), prob_7_rate(n)] = F_percent_IE(num_random, num_repeat, prob_7_Ex, prob_7_In, spike_num_Poi, noise_magnitude, rate_range, num_decay);
end
%%
XTickText{1} = '100'; % (Continuous) or 100
XTickText{2} = '75';
XTickText{3} = '50';
XTickText{4} = '25';
XTickText{5} = '6.7'; % (Equal Prob.) or 6.7

figure;
prob_all_percent = [prob_100_percent  prob_75_percent prob_50_percent prob_25_percent prob_7_percent]*100;
for n = 1 : N
    plot(prob_all_percent(n, :), 'color',rgb('Silver'),'Marker','o','MarkerSize',8,'LineWidth', 1); hold on
end
plot( mean(prob_all_percent),'color',rgb('Black'),'Marker','o','MarkerSize',8,'LineWidth',2);

ha = gca;
set(ha,'XTick', 1:5,'XTickLabel',XTickText,'FontName','Arial','FontSize',14);
set(ha,'XLimMode','Manual','XLim', [0 6]);
set(ha,'YLimMode','Manual','YLim', [0 80]);

set(ha,'Box','Off');
h_ylabel = ylabel('Percent (%)');
set(h_ylabel,'FontName','Arial','FontSize',14);
h_xlabel = xlabel('Target Speaker Probability (%)');
set(h_xlabel,'FontName','Arial','FontSize',14);
hf = gcf;
set(hf,'Color','White');
title('Facilitation phase total duration')
%%
figure;
prob_all_percent_L = [prob_100_percent_L  prob_75_percent_L prob_50_percent_L prob_25_percent_L]*100;
no_L = prob_100_percent_L==0;
prob_all_percent_L(no_L, :) = [];
for n = 1 : size(prob_all_percent_L, 1)
    plot(prob_all_percent_L(n, :), 'color',rgb('Silver'),'Marker','o','MarkerSize',8,'LineWidth',2); hold on
end
plot( mean(prob_all_percent_L),'color',rgb('Black'),'Marker','o','MarkerSize',8,'LineWidth',2);

ha = gca;
set(ha,'XTick', 1:4,'XTickLabel',XTickText,'FontName','Arial','FontSize',14);
set(ha,'XLimMode','Manual','XLim', [0 5]);
set(ha,'YLimMode','Manual','YLim', [0 80]);

set(ha,'Box','Off');
h_ylabel = ylabel('Percent (%)');
set(h_ylabel,'FontName','Arial','FontSize',14);
h_xlabel = xlabel('Target Speaker Probability (%)');
set(h_xlabel,'FontName','Arial','FontSize',14);
hf = gcf;
set(hf,'Color','White');
title('Long facilitation phase total duration')
%%
figure;
prob_all_rate = [prob_100_rate  prob_75_rate prob_50_rate prob_25_rate prob_7_rate];
for n = 1 : N
    plot(prob_all_rate(n, :), 'color',rgb('Silver'),'Marker','o','MarkerSize',8,'LineWidth',2); hold on
end
plot(mean(prob_all_rate),'color',rgb('Black'),'Marker','o','MarkerSize',8,'LineWidth',2);
ha = gca;
set(ha,'XTick', 1:5,'XTickLabel',XTickText,'FontName','Arial','FontSize',14);
set(ha,'XLimMode','Manual','XLim', [0 6]);
set(ha,'YLimMode','Manual','YLim', [0 20]);

set(ha,'Box','Off');
h_ylabel = ylabel('Firing rate (spikes/s)');
set(h_ylabel,'FontName','Arial','FontSize',14);
h_xlabel = xlabel('Target Speaker Probability (%)');
set(h_xlabel,'FontName','Arial','FontSize',14);
hf = gcf;
set(hf,'Color','White');
title('Firing rate changes')