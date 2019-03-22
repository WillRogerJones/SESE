function runModel()
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%runs the model
%modify parameters in code to determine wich conditions, number of targets
%and SOA to run
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

global SOA onetarg don0t dot1 dot2 singletrial
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%These parameters determine which conditions are run.  

% SOA = SOAtorun;
%set onetarg to 1 for one target
onetarg = 0;

singletrial = 0;

SOAtorun = 100;

%Set to zero to skip this condition
don0t = 1;  %basic
dot1 = 0;   %T1+1 blank
dot2 = 0;   %T2+1 blank
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%run the model
for (run = 1:length(SOAtorun))
    SOA = SOAtorun(run);
    bigbattery
end


