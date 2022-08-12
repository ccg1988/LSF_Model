Using EI-LIF model (here called IE) and MP-LIF models to reproduce the location specific facilitation (LSF).

The backbone of this project is leaky integrate and fire (LIF) model---function: LIFmodel_IE.m and LIFmodel_MP.m 
LIF a very basic model for simulating neural firing and the code is inspired by Bendor, PLOS Computational Biology, 2015.

Based on LIF model, there are inhibitory-excitatory synaptic depression (aka IE-LIF) model and membrane potential depolarization (aka MP-LIF) model. 
Synaptic depression is also a very basic model (refer to Dayan&Abbott, 2001, Page 185) and 
the code is inspired by Lee et al., PLOS Computational Biology, 2020. 
Membrane potential depolarization came from our experimental data obtained with in vivo intracellular recordings.

For reproducing LSF with IE-LIF model, you need to load the parameters of synaptic depression at five probabilities (included). For example, "I_prob_75_tau10s.mat" indicates the probability is 75% 
and the recovery time of inhibitory synapse is 10second (excitatory synapse is 20s). 
Those parameters were generated in "adaptation_IE.m".
For reproducing LSF with MP-LIF model, you don't need to load any parameters.

%%%%%%%%%%%%%%%%%%%%%%%%%%%5%%%%%%%%%%%% How to use the codes %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
For reproducing LSF of single neuron at 100% probability, run---F_demo_IE.m and F_demo_MP.m.

For comparing faciliation percents among 100%, 75%, 50%, 25% and 6.7% probabilities, run---F_percent_IE_master.m and F_percent_MP_master.m.

All other .m files are functions and will be called by above four programs.

I have run, commented and checked those codes before uploading (Jun 5th, 2022, MATLAB2022a). 
Feel free to contact me if you have any issues.
cheng-gang.chen@jhu.edu