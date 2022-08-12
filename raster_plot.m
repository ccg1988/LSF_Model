function raster_plot(x, raster, num_random, num_repeat, PREstimulus_duration, stimulus_duration, POSTstimulus_duration, spike_distribution)

% copied and modified this function from Bendor, PLOS Computational Biology, 2015
% by CCG @ 2021-12-07

nreps = num_random + num_repeat ;
xtext = [];
xtext_position = [];
for s = 1:2:length(x)
    xtext_position = [xtext_position;s];
    xtext = char(xtext, num2str(x(s)));
end
xtext(1,:) = [];


ytext_position = [20 120 220 320];
ytext = num2str((ytext_position-20)');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
pos=get(0,'ScreenSize'); X_size=pos(3);Y_size=pos(4);
figure('position',[X_size*0.05 Y_size*0.1 X_size*0.9 Y_size*0.8]); % for 300 repeats large figure
% figure('position',[X_size*0.05 Y_size*0.3 X_size*0.9 Y_size*0.4]); % for 100 repeats small figure

h_axes1 = axes('position',[0.05 0.1 0.6 0.8]);     %Left (raster plot)
axes(h_axes1);
hold on
xlabel('Time (s)')
ylabel('Trial #')

plot(raster.spikes, nreps*(raster.stim-1)+raster.rep,'k.','MarkerSize',9);
% 
axis([-PREstimulus_duration stimulus_duration+POSTstimulus_duration 0 length(x)*nreps+1])
set(gca,'yTickMode','manual');
set(gca,'yTick', ytext_position);
set(gca,'yTickLabel', ytext);
set(h_axes1,'Box','off','LineWidth',1,'FontName','Arial','FontSize',12)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
h_axes2 = axes('position',[0.7 0.1 0.10 0.8]);     %Right (firing plot) X-start, Y-start, X-size, Y-size
axes(h_axes2);
hold on
xlabel('Trial #')
ylabel('Firing rate')
plot(spike_distribution,'-','Color', 'k','Marker','.', 'MarkerSize',10); xlim([1 length(spike_distribution)])
hold on;
f_thres = mean(spike_distribution(1:num_random))+std(spike_distribution(1:num_random));
f_thres_trace = f_thres*ones(length(spike_distribution), 1);
f_percent=length(find(spike_distribution((num_random+1):end)>f_thres))/num_repeat;
plot(f_thres_trace); 
set(gca,'xTickMode','manual');
set(gca,'xTick', ytext_position);
set(gca,'xTickLabel', ytext);
set(gca,'view',[90 -90])

t = spike_distribution((num_random+1):end)>f_thres;
id_start = strfind([0 t], [0 1]) ; %gives indices of beginning of groups
id_end = strfind([t 0], [1 0]) ;  %gives indices of end of groups
seg_length = (id_end - id_start)+1 ;% [1 2 3] has 3 elements (3-1)+1
id_seg = seg_length >= 5 ;
f_long_percent = sum(seg_length(id_seg))/num_repeat;
firing_rate = mean(spike_distribution((num_random+1):end));

title(['Percent(%) ', num2str(f_percent*100), ' Long percent(%) ', num2str(f_long_percent*100), ' Rate(/s)', num2str(firing_rate)])