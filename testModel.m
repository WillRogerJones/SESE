function testModel(singletarg,SOAtorun,val,basic,blank)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%runs the model
%modify parameters in code to determine wich conditions, number of targets
%and SOA to run
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

global SOA onetarg don0t dot1 dot2 singletrial runval
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%These parameters determine which conditions are run.  

% SOA = SOAtorun;
%set onetarg to 1 for one target
onetarg = singletarg;

runval = val;

%run a single trial for test purpose
singletrial = 1;

%for two targets run the model with 100 ms for one target also with 50ms
% if(onetarg)
    SOA = SOAtorun;
% else
%     SOAtorun = [100];
% end

%Set to zero to skip this condition
don0t = basic;  %basic
dot1 = blank;   %T1+1 blank
dot2 = 0;   %T2+1 blank
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%run the model
% for (run = 1:length(SOAtorun))
% SOA = SOAtorun(run);
    bigbattery
% end


