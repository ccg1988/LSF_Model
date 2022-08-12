% modified from LIFmodel_basic (Bendor, PLOS Computational Biology, 2015)
% call "LIFmodel_MP.m" & "raster_plot.m"
% just model, without loading data
% by CCG @ 2021-12-05

clear; clc
%%%%%%%%%%%%%%%%%%%%%%%%%%%model parameters%%%%%%%%%%%%%%%%%%%%%%%%%%
spike_num_Poi = 30 ; % Number of Possion spikes
    %1 means the Espike is same to Erest but just add 0.02---strongly inhibition==adaptation
    % 0.001 means Espike is unchanged, thus higher MP will has more AP---strongly excitation==facilitation
Espike_scale = 0.3 ; 
noise_magnitude = 2.5e-8 ; %default noise level in conductance--decide spontaneous and evoked spikes

num_random = 20 ;
num_repeat = 300 ;
nreps = num_random+num_repeat ;
step=.0001; % [S]

IE_ratio = 1 ;
synapse_num_Ex = 10 ;    % N excitatory synaptic inputs (Wehr and Zador)
synapse_num_In = 10 ;    % N inhibitory synaptic inputs

depo_value = 0.007 ;  %de-polarize 7mV_____FIXED
Erest_base = -0.069 ; %default is -0.065V(-65 mV); more negative, more spikes_____FIXED
Erest_depo = Erest_base + depo_value ;

num_Erest_step = 30 ; % number of trials to deporalize_____FIXED
Erest_step = (Erest_depo-Erest_base)/(num_Erest_step-1) ;
Erest_slope = (Erest_base : Erest_step: Erest_depo) ; 

Erest = nan(nreps, 1) ;
Erest(1:num_random) = Erest_base*ones(num_random, 1) ;
Erest((num_random+1):(num_random+num_Erest_step)) = Erest_slope ;
Erest((num_random+num_Erest_step+1):end) = Erest_depo*ones((nreps-num_random-num_Erest_step), 1) ;

Espike = Erest_base*ones(nreps, 1) ; %Espike has same base as Erest
if depo_value>0
    Espike_depo = Erest_base + depo_value*Espike_scale ;
    Espike_step = (Espike_depo-Erest_base)/(num_Erest_step-1) ;
    Espike_slope = (Erest_base : Espike_step: Espike_depo) ;
    Espike((num_random+1):(num_random+num_Erest_step)) = Espike_slope; %2nd part---transition
    Espike((num_random+num_Erest_step+1):end) = (Erest_base + depo_value*Espike_scale)*ones((nreps-num_random-num_Erest_step), 1) ; %3rd part---de-polarization
end
spike_thres = Espike + 0.02 ;  %20 mV above Erest as spike threshold; more negative, more spikes
% figure;plot(spike_thres); hold on; plot(Erest)
%%
MP_noise_magnitude = 2/1000 ;
% MP_noise_magnitude = 0 ;
Erest= Erest + MP_noise_magnitude*randn(nreps, 1);

IE_delay = 0.0 ; % + means Ex lead In, longer delay==more spikes
E_strength = ones(nreps, 1) ; 
I_strength = ones(nreps, 1) * IE_ratio ; %more trials in the <equal-presentation-mode> will make the results more reliable

kernel_time_constant=.005;  %time constant of 5 ms (Wehr and Zador)
%%%%%%%%%%%%%%%%%%%%%%%%%%%acoustic pulse train stimulus%%%%%%%%%%%%%%%%%%%%%%%%%%
stimulus_duration=0.5;  %half second
PREstimulus_duration=0.2;  
POSTstimulus_duration=0.3; 
%%%%%%%%%%%%%%%%%%%%%%%%%%%acoustic pulse train stimulus%%%%%%%%%%%%%%%%%%%%%%%%%%
spike_distribution=NaN(1, nreps);
spont_distribution=NaN(1, 1*nreps);
raster.stim=[];  raster.rep=[];  raster.spikes=[];

t=step:step:(kernel_time_constant*10);
kernel=t.*exp(-t/kernel_time_constant); %1D vector  a=1/kernel_time_constant
kernel=1e-9*kernel/max(kernel); %amplitude of 1 nS (shape of single spike)
%%
input=zeros(size(step:step:(POSTstimulus_duration+stimulus_duration)));
stimulus_input_length=length(step:step:(stimulus_duration));
total_points = (stimulus_duration+PREstimulus_duration+POSTstimulus_duration)/step;
% MP_all = nan (total_points, nreps);
for r = 1 : nreps %nreps
    E_input = input;
    I_input = input;
    spike_num = poissrnd(spike_num_Poi);
    spike_gap = floor(stimulus_input_length/spike_num) ;
    for i = 1 :  spike_num
        time_window_end = (i-1)*spike_gap + length(kernel);
        time_window_start = 1 + time_window_end-length(kernel);
        time_window = time_window_start : time_window_end ;
        E_input (time_window) =  E_input (time_window)+kernel*synapse_num_Ex; %assign curve at specific point range
        I_input (time_window) = I_input (time_window)+kernel*synapse_num_In;
    end
    
    delay=round(abs(IE_delay)/(1000*step));  % delay in steps, single value
    delay_chunk=zeros(1,delay); %1D vector
    Ge=E_input * E_strength(r); %number of kernels * kernel amplitude(A; nS)
    Gi=[delay_chunk I_input(1:(length(I_input)-delay))] * I_strength(r);
 
    pre_chunk=zeros(size(step : step : PREstimulus_duration)); %1D vector
    Ge=[pre_chunk Ge]; %add pre stim time
    Gi=[pre_chunk Gi];  
 
    [spikes, MP_all] = LIFmodel_MP(Ge, Gi, noise_magnitude, Erest(r), spike_thres(r)); %Excitatory and Inhibitory conductance (nS)!!!
    spikes=spikes-PREstimulus_duration; %negative value means the AP is during Prestimulus period
    spike_distribution(r)=length( spikes(spikes>0 & spikes<=stimulus_duration))/stimulus_duration; %spike rate (w/o spon) during sound
    spont_distribution(r)=length( spikes(spikes>-PREstimulus_duration & spikes<0) )/PREstimulus_duration; %spon rate during pre-sound
    
    raster.stim=[raster.stim ones(size(spikes))];
    raster.rep=[raster.rep r*ones(size(spikes))];
    raster.spikes=[raster.spikes spikes];
end
spike_distribution_driven = spike_distribution - spont_distribution ;
raster_plot(1000, raster, num_random, num_repeat, PREstimulus_duration, stimulus_duration, POSTstimulus_duration, spike_distribution_driven)