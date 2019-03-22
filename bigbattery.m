function bigbattery
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%This script runs the model several times, simulating several conditions.
%Use flags in code following global var declaration to choose the
%conditions to be run.
%
%Conditions are:  Basic, T1+1 blank,  T2+1 blank
%8 lags between T1 and T2 are run (repeatedly) for each condition
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

global T1BLANK T2BLANK T1BLANK2 genval genval2 BASICRSVP T2perf distval T1perf Swapencoding NUMLAYERS NUMSTREAMS
global BatT1Perf BatT2Perf BatT1CPerf BatT2CPerf Batswap T1batterydata T2batterydata Swapbatterydata
global Equalgens doubleencoding Batdoub doubledata  don0t dot1 dot2
global PresynapHistory ExPostsynHistory InhibPostsynHistory MembPotHistory ExPostsynFull
global summate summateacc summatecount summate2 summateacc2 summatecount2 summateflag summateflag2
global SOA runlength onetarg accuracy singletrial runval

% allow T2+1 blank only for 2 target
if(onetarg)
    dot2 = 0;   %T2+1 blank
end

%model run stopwatch start
tic;

%set to 1 for equal T1 and T2
Equalgens = 0;

inputpatterns   %setup the RSVP streams
architecture    %setup the network

% specify lag - set to 0 to do 1:NUMSTREAMS lags - only lag 1 for single
% target
%initialize numlags var
numlags = 0;
if (onetarg)
    lag = 1;
    numlags = 1;
else
    lag = 0;
    numlags = NUMSTREAMS;
end

%check how many conditions were run - basic, blanks, etc
numconditions = 1;
if (dot1)
    numconditions = 2;
end
if(dot2)
    numconditions = 3;
end

% iterate the value of T1 and T2 over this range, at this resolution
resolution = .025;

varstart = floor(-.1625/resolution)
varstop = floor(.1625/resolution)

%run a single trial for test purpose
if(singletrial)
    varstart = runval;
    varstop = runval;
end

%So the strength of the target will iterate from -.078 to +.078 (added to the
%baseline value (as defined below)) in steps of .012
baseval = .570;

%this will happen conjunctively for every possible combination of T1 and T2

%So there are 6+1+6 = 13 steps for T1 and T2, leading to 169 runs of all 8 lags in the two target condition.
numTcombi = (-varstart+varstop+1)^2;
%for onetarget less possible target values
if(onetarg)
    numTcombi = (-varstart+varstop+1);
end

%variables for storing the raw activation values of individual neurons
%summate(trialnum,timestep,layer,neuron)
%these variables are encoded in the function evaltargs.m
summate = zeros(numTcombi,NUMSTREAMS,runlength,3,2);
summateacc = zeros(400, 3);
summatecount = zeros(NUMSTREAMS,numTcombi);

summate2 = zeros(numTcombi,NUMSTREAMS,runlength,3,2);
summateacc2 = zeros(400, 3);
summatecount2 = zeros(NUMSTREAMS,numTcombi);

%behavioural storage variable
T1batterydata= 0; %values for T1 for each trial - encodes whatever is in neuron 1 so ok for single target
T2batterydata = 0; %values for T2 for each trial - neuron 2
Swapbatterydata = 0;
doubledata = 0;

offset = 1-varstart;

%Flags for storing output traces
summateflag = 1;
summateflag2 = 1;

%if onetarget do only one set of target values
T1start = varstart;
T1stop = varstop;

%stop running two nested loops for onetarget
if(onetarg)
    T2start = 0;
    T2stop = 0;
else
    T2start = varstart;
    T2stop = varstop;
end

if(singletrial)
    numeasy = 1;
    numhard = 1;
else
    numeasy = varstop;
    numhard = -varstart;
end

%%%%%%%%%%%%%%%%%%  FIRST RUN: Basic Condition
if(don0t)
    %Flags used later to insert blanks into the stream  These variables are used in generateinput.m
    T1BLANK = 0;  %T1+1 blank
    T2BLANK = 0;   %T2+1 blank
    T1BLANK2 = 0;   %T1 +2 blank
    trialcounter = 1;
    accuracy = zeros(1,numlags);
    BasicAccu = zeros(numTcombi,numlags);
    %initialise ERP storage
    MembPotBat_basic = zeros(numTcombi,NUMSTREAMS,runlength,NUMLAYERS);
    PresynapBat_basic = zeros(numTcombi,NUMSTREAMS,runlength,NUMLAYERS);
    ExPostsynBat_basic = zeros(numTcombi,NUMSTREAMS,runlength,NUMLAYERS);
    ExPostsynFull_basic = zeros(numTcombi,NUMSTREAMS,runlength,NUMLAYERS, 40);
    InhibPostsynBat_basic = zeros(numTcombi,NUMSTREAMS,runlength,NUMLAYERS);
    if(onetarg)
        EasyAccu = zeros(numeasy,numlags);
        easycount = 1;
        MembPotBat_easy = zeros(numeasy,NUMSTREAMS,runlength,NUMLAYERS);
        PresynapBat_easy = zeros(numeasy,NUMSTREAMS,runlength,NUMLAYERS);
        ExPostsynBat_easy = zeros(numeasy,NUMSTREAMS,runlength,NUMLAYERS);
        InhibPostsynBat_easy = zeros(numeasy,NUMSTREAMS,runlength,NUMLAYERS);
        HardAccu = zeros(numhard,numlags);
        hardcount = 1;
        MembPotBat_hard = zeros(numhard,NUMSTREAMS,runlength,NUMLAYERS);
        PresynapBat_hard = zeros(numhard,NUMSTREAMS,runlength,NUMLAYERS);
        ExPostsynBat_hard = zeros(numhard,NUMSTREAMS,runlength,NUMLAYERS);
        InhibPostsynBat_hard = zeros(numhard,NUMSTREAMS,runlength,NUMLAYERS);
    end

    for(i=T1start:T1stop)
        for(j=T2start:T2stop)
            genval = baseval + i * resolution;
            genval2 = baseval + j *resolution;
            first = i+offset; %i loop index
            if(singletrial | onetarg)
                second = 1;
            else
                second = j+offset; %j loop index
            end
            distval = baseval;

            if (onetarg)
                sprintf('This set of lags: Target has value %0.4f - Distractors have value %0.4f',genval,distval)
            else
                sprintf('This set of lags: T1 has value %0.4f - T2 has value %0.2f - Distractors have value %0.4f',genval,genval2,distval)
            end


            %%%%%%this line actually runs the model%%%%%%
            runRSVP(BASICRSVP,lag)           
            %print trial info
            sprintf('%d target combinations left in basic condition',numTcombi-trialcounter)
            
            %these store the output
            BasicAccu(trialcounter,:) = accuracy;
            T1batterydata(1,first,second,1:8) = reshape(T1perf,[1,1,1,8]);
            T2batterydata(1,first,second,1:8) = reshape(T2perf,[1,1,1,8]);
            Swapbatterydata(1,first,second,1:8) = reshape(Swapencoding,[1,1,1,8]);
            doubledata(1,first,second,1:8) =  reshape(doubleencoding,[1,1,1,8]);

            %copy erp data to battery wide variable here
            %membrane potentials
            %number of runs,lag,timestep,layers
            MembPotBat_basic(trialcounter,:,:,:) = MembPotHistory;
            %presynaptic output
            PresynapBat_basic(trialcounter,:,:,:) = PresynapHistory;
            %excitatory postsynaptic output
            ExPostsynBat_basic(trialcounter,:,:,:) = ExPostsynHistory;
            %excitatory postsynaptic output by neuron
            ExPostsynFull_basic(trialcounter,:,:,:,:) = ExPostsynFull;
            %inhibitory postsynaptic output
            InhibPostsynBat_basic(trialcounter,:,:,:) = InhibPostsynHistory;
            if(onetarg)
                %easy/hard currently only for single target
                if(genval > baseval) %easy target
                    EasyAccu(easycount,:) = accuracy;
                    %membrane potentials
                    %number of runs,lag,timestep,layers
                    MembPotBat_easy(easycount,:,:,:) = MembPotHistory;
                    %presynaptic output
                    PresynapBat_easy(easycount,:,:,:) = PresynapHistory;
                    %excitatory postsynaptic output
                    ExPostsynBat_easy(easycount,:,:,:) = ExPostsynHistory;
                    %inhibitory postsynaptic output
                    InhibPostsynBat_easy(easycount,:,:,:) = InhibPostsynHistory;                    
                    easycount = easycount + 1;
                else %hard target
                    HardAccu(hardcount,:) = accuracy;
                    %membrane potentials
                    %number of runs,lag,timestep,layers
                    MembPotBat_hard(hardcount,:,:,:) = MembPotHistory;
                    %presynaptic output
                    PresynapBat_hard(hardcount,:,:,:) = PresynapHistory;
                    %excitatory postsynaptic output
                    ExPostsynBat_hard(hardcount,:,:,:) = ExPostsynHistory;
                    %inhibitory postsynaptic output
                    InhibPostsynBat_hard(hardcount,:,:,:) = InhibPostsynHistory;
                    hardcount = hardcount + 1;
                end
            end
            
            trialcounter = trialcounter + 1;
        end
    end
    if(onetarg)
        erpfile = [ 'STSTerp_1targ_' num2str(SOA) 'ms' ];
        save(erpfile,'MembPotBat_*', 'PresynapBat_*', 'ExPostsynBat_*','InhibPostsynBat_*','BasicAccu','EasyAccu','HardAccu');
    else
        erpfile = [ 'STSTerp_' num2str(SOA) 'ms' ];
        save(erpfile,'MembPotBat_*', 'PresynapBat_*', 'ExPostsynBat_*','InhibPostsynBat_*','BasicAccu', 'ExPostsynFull_*' , '-v7.3');
    end
    clear MembPotBat_* PresynapBat_* ExPostsynBat_* InhibPostsynBat_*;
end

%%%%%%%%%%%%%%%%%%SECOND RUN: T1+1 Blank Condition
if(dot1)
    T1BLANK2 = 0;
    T1BLANK = 1;
    T2BLANK = 0;
    trialcounter = 1;
    accuracy = zeros(1,numlags);
    BlankAccu = zeros(numTcombi,numlags);
    summateflag = 0;
    summateflag2 = 1;
    %initialise ERP storage
    MembPotBat_T1blank = zeros(numTcombi,NUMSTREAMS,runlength,NUMLAYERS);
    PresynapBat_T1blank = zeros(numTcombi,NUMSTREAMS,runlength,NUMLAYERS);
    ExPostsynBat_T1blank = zeros(numTcombi,NUMSTREAMS,runlength,NUMLAYERS);
    InhibPostsynBat_T1blank = zeros(numTcombi,NUMSTREAMS,runlength,NUMLAYERS);
    if(onetarg)
        BlankEasyAccu = zeros(numeasy,numlags);
        easycount = 1;
        MembPotBat_blankeasy = zeros(numeasy,NUMSTREAMS,runlength,NUMLAYERS);
        PresynapBat_blankeasy = zeros(numeasy,NUMSTREAMS,runlength,NUMLAYERS);
        ExPostsynBat_blankeasy = zeros(numeasy,NUMSTREAMS,runlength,NUMLAYERS);
        InhibPostsynBat_blankeasy = zeros(numeasy,NUMSTREAMS,runlength,NUMLAYERS);
        BlankHardAccu = zeros(numhard,numlags);
        hardcount = 1;
        MembPotBat_blankhard = zeros(numhard,NUMSTREAMS,runlength,NUMLAYERS);
        PresynapBat_blankhard = zeros(numhard,NUMSTREAMS,runlength,NUMLAYERS);
        ExPostsynBat_blankhard = zeros(numhard,NUMSTREAMS,runlength,NUMLAYERS);
        InhibPostsynBat_blankhard = zeros(numhard,NUMSTREAMS,runlength,NUMLAYERS);
    end

    for(i=T1start:T1stop)
        for(j=T2start:T2stop)
            genval = baseval + i * resolution;
            genval2 = baseval + j* resolution;
            distval = baseval;

            first = i+offset;
            if(singletrial | onetarg)
                second = 1;
            else
                second = j+offset; %j loop index
            end

            if (onetarg)
                sprintf('This set of lags: Target has value %0.4f - Distractors have value %0.4f',genval,distval)
            else
                sprintf('This set of lags: T1 has value %0.4f - T2 has value %0.2f - Distractors have value %0.4f',genval,genval2,distval)
            end

            %%%%%%this line actually runs the model%%%%%%
            runRSVP(BASICRSVP,lag)
            %print trial info
            sprintf('%d target combinations left in T1+1 blank condition',numTcombi-trialcounter)
            
            %these store the output
            BlankAccu(trialcounter,:) = accuracy;
            T1batterydata(2,first,second,1:8) = reshape(T1perf,[1,1,1,8]);
            T2batterydata(2,first,second,1:8) = reshape(T2perf,[1,1,1,8]);
            Swapbatterydata(2,first,second,1:8) = reshape(Swapencoding,[1,1,1,8]);
            doubledata(2,first,second,1:8) =  reshape(doubleencoding,[1,1,1,8]);

            %copy erp data to battery wide variable here
            %membrane potentials
            %number of runs,lag,timestep,layers
            %use only accuracy trials
            MembPotBat_T1blank(trialcounter,:,:,:) = MembPotHistory;
            %presynaptic output
            PresynapBat_T1blank(trialcounter,:,:,:) = PresynapHistory;
            %excitatory postsynaptic output
            ExPostsynBat_T1blank(trialcounter,:,:,:) = ExPostsynHistory;
            %inhibitory postsynaptic output
            InhibPostsynBat_T1blank(trialcounter,:,:,:) = InhibPostsynHistory;
            if(onetarg)
                %blanked easy/hard currently only for single target
                if(genval > baseval) %blanked easy target
                    BlankEasyAccu(easycount,:) = accuracy;
                    %membrane potentials
                    %number of runs,lag,timestep,layers
                    MembPotBat_blankeasy(easycount,:,:,:) = MembPotHistory;
                    %presynaptic output
                    PresynapBat_blankeasy(easycount,:,:,:) = PresynapHistory;
                    %excitatory postsynaptic output
                    ExPostsynBat_blankeasy(easycount,:,:,:) = ExPostsynHistory;
                    %inhibitory postsynaptic output
                    InhibPostsynBat_blankeasy(easycount,:,:,:) = InhibPostsynHistory;
                    easycount = easycount + 1;
                else %blanked hard target
                    BlankHardAccu(hardcount,:) = accuracy;
                    %membrane potentials
                    %number of runs,lag,timestep,layers
                    MembPotBat_blankhard(hardcount,:,:,:) = MembPotHistory;
                    %presynaptic output
                    PresynapBat_blankhard(hardcount,:,:,:) = PresynapHistory;
                    %excitatory postsynaptic output
                    ExPostsynBat_blankhard(hardcount,:,:,:) = ExPostsynHistory;
                    %inhibitory postsynaptic output
                    InhibPostsynBat_blankhard(hardcount,:,:,:) = InhibPostsynHistory;
                    hardcount = hardcount + 1;
                end
            end            
            trialcounter = trialcounter + 1;
        end
    end
    if(onetarg)
        erpfile = [ 'STSTerp_1targ_' num2str(SOA) 'ms' ];
        save(erpfile,'MembPotBat_*', 'PresynapBat_*', 'ExPostsynBat_*','InhibPostsynBat_*','BlankAccu','BlankEasyAccu','BlankHardAccu','-append');
    else
        erpfile = [ 'STSTerp_' num2str(SOA) 'ms' ];
        save(erpfile,'MembPotBat_*', 'PresynapBat_*', 'ExPostsynBat_*','InhibPostsynBat_*','BlankAccu','-append');
    end
    clear MembPotBat_* PresynapBat_* ExPostsynBat_* InhibPostsynBat_*;
end

%%%%%%%%%%%%%%%%%%%%THIRD RUN: T2+1 blank condition
if(dot2)
    summateflag2 = 0;
    T1BLANK = 0;
    T2BLANK = 1;
    trialcounter = 1;
    accuracy = zeros(1,numlags);
    T2BlankAccu = zeros(numTcombi,numlags);
    %initialise ERP storage
    MembPotBat_T2blank = zeros(numTcombi,NUMSTREAMS,runlength,NUMLAYERS);
    PresynapBat_T2blank = zeros(numTcombi,NUMSTREAMS,runlength,NUMLAYERS);
    ExPostsynBat_T2blank = zeros(numTcombi,NUMSTREAMS,runlength,NUMLAYERS);
    InhibPostsynBat_T2blank = zeros(numTcombi,NUMSTREAMS,runlength,NUMLAYERS);

    for(i=T1start:T1stop)
        for(j=T2start:T2stop)
            genval = baseval + i * resolution;
            genval2 = baseval + j * resolution;
            distval = baseval;

            first = i+offset;
            if(singletrial | onetarg)
                second = 1;
            else
                second = j+offset; %j loop index
            end

            if (onetarg)
                sprintf('This set of lags: Target has value %0.4f - Distractors have value %0.4f',genval,distval)
            else
                sprintf('This set of lags: T1 has value %0.4f - T2 has value %0.2f - Distractors have value %0.4f',genval,genval2,distval)
            end


            %%%%%this line actually runs the model%%%%%%
            runRSVP(BASICRSVP,lag)
            %print trial info
            sprintf('%d target combinations left in T2+1 blank condition',numTcombi-trialcounter)

            T2BlankAccu(trialcounter,:) = accuracy;
            T1batterydata(3,first,second,1:8) = reshape(T1perf,[1,1,1,8]);
            T2batterydata(3,first,second,1:8) = reshape(T2perf,[1,1,1,8]);
            Swapbatterydata(3,first,second,1:8) = reshape(Swapencoding,[1,1,1,8]);
            doubledata(3,first,second,1:8) =  reshape(doubleencoding,[1,1,1,8]);

            %copy erp data to battery wide variable here
            %membrane potentials
            %number of runs,lag,timestep,layers
            MembPotBat_T2blank(trialcounter,:,:,:) = MembPotHistory;
            %presynaptic output
            PresynapBat_T2blank(trialcounter,:,:,:) = PresynapHistory;
            %excitatory postsynaptic output
            ExPostsynBat_T2blank(trialcounter,:,:,:) = ExPostsynHistory;
            %inhibitory postsynaptic output
            InhibPostsynBat_T2blank(trialcounter,:,:,:) = InhibPostsynHistory;
            trialcounter = trialcounter + 1;
        end
    end
    if(onetarg)
        erpfile = [ 'STSTerp_1targ_' num2str(SOA) 'ms' ];
        save(erpfile,'MembPotBat_*', 'PresynapBat_*', 'ExPostsynBat_*','InhibPostsynBat_*','T2BlankAccu','-append');
    else
        erpfile = [ 'STSTerp_' num2str(SOA) 'ms' ];
        save(erpfile,'MembPotBat_*', 'PresynapBat_*', 'ExPostsynBat_*','InhibPostsynBat_*','T2BlankAccu','-append');
    end
    clear MembPotBat_* PresynapBat_* ExPostsynBat_* InhibPostsynBat_*;
end


%go through all of the stored output of the model and compute the accuracies.

%onetarget only has T1 data
BatT1Perf = zeros(numconditions,numlags);

if(~onetarg)
    BatT2Perf = zeros(numconditions,numlags);
    BatT2CPerf = zeros(numconditions,numlags);
    BatT1CPerf = zeros(numconditions,numlags);
    Batswap = zeros(numconditions,numlags);
    Batdoub = zeros(numconditions,numlags);
end

% copy target performance data to battery wide variable
for(t = 1:numconditions)
    for(i = 1:size(T1batterydata,2))%first (i) loop index
        for(j = 1:size(T1batterydata,3))%second (j) loop index
            for(k = 1:numlags)
                if(~onetarg)
                    doub = doubledata(t,i,j,k);
                    t2 = T2batterydata(t,i,j,k);
                end
                t1 = T1batterydata(t,i,j,k);
                if(t1) %not zero
                    BatT1Perf(t,k)= BatT1Perf(t,k)+ 1;
                end
                if(~onetarg)
                    if(t2)
                        BatT2Perf(t,k)= BatT2Perf(t,k)+ 1;
                    end
                    Batdoub(t,k) = Batdoub(t,k) + doub;
                    if(t1 & t2)
                        BatT2CPerf(t,k)= BatT2CPerf(t,k)+ 1;
                    end
                    if(t2)
                        BatT1CPerf(t,k)= BatT1CPerf(t,k)+ 1;
                    end
                    if(t1 & t2)
                        Batswap(t,k) = Batswap(t,k) + Swapbatterydata(t,i,j,k);
                    end
                end
            end
        end
    end
    for(k = 1:numlags)
        if(~onetarg)
            Batdoub(t,k) = Batdoub(t,k)/BatT2CPerf(t,k);
            Batswap(t,k) = Batswap(t,k)/BatT2CPerf(t,k);
            BatT1CPerf(t,k) = BatT2CPerf(t,k) / BatT2Perf(t,k);
            BatT2CPerf(t,k) = BatT2CPerf(t,k) / BatT1Perf(t,k);
            BatT2Perf(t,k) = BatT2Perf(t,k) / numTcombi;
        end
        BatT1Perf(t,k) = BatT1Perf(t,k) / numTcombi;
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Save the behavioural output
%Duration
duration = floor(toc/60);
sprintf('Model ran for %d minutes',duration)

%accuracy and model performance on target detection
% if(onetarg)
%     outfile = [ 'STSToutput_1targ_' num2str(SOA) 'ms' ];
%     save(outfile, 'duration','BatT1Perf','T1batterydata');
% else
%     outfile = [ 'STSToutput_' num2str(SOA) 'ms' ];
%     save(outfile, 'duration','BatT2Perf','BatT1Perf','BatT2CPerf','BatT1CPerf','Batswap','Batdoub', 'doubledata','T1batterydata','T2batterydata','Swapbatterydata' );
% end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% including summate stuff
if(onetarg)
    outfile = [ 'STSToutput_1targ_' num2str(SOA) 'ms' ];
    save(outfile, 'duration', 'summate','summatecount','summateacc', 'summate2','summatecount2','summateacc2','BatT1Perf','T1batterydata');
else
    outfile = [ 'STSToutput_' num2str(SOA) 'ms' ];
    save(outfile, 'duration', 'summate','summatecount','summateacc', 'summate2','summatecount2','summateacc2','BatT2Perf','BatT1Perf','BatT2CPerf','BatT1CPerf','Batswap','Batdoub', 'doubledata','T1batterydata','T2batterydata','Swapbatterydata' );
end
