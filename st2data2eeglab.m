function st2data2eeglab(study)
%parameter: study - single target (1) or two target (2)
%load st2model data and save for eeglab usage
%creates following vERP channels
%1 - vP3
%2 - vN2pc
%3 - vSSVEP
%4 - T1P3
%5 - T2P3
%6 - Input
%7 - Binding pool gate
%add event markers

if study == 1
    disp('Loading workspace vars..');
    load /Users/pc/Documents/PhD/modelling/ST2/trunk/STSTerp_1targ_50ms.mat;
    load /Users/pc/Documents/PhD/modelling/ST2/trunk/STST_T1T2trace_1targ_50ms.mat;
    setname = 'SingleT';
    numlags = 1;
    segstart = 80;
    retinadelay = 14;
    numtimepoints = size(ExPostsynBat_basic,3)-(segstart-1);
elseif study == 2
    disp('Loading workspace vars..');
     load /Users/pc/Documents/PhD/modelling/ST2/trunk/STSTerp_100ms_ExPostSynOnly.mat;
     load /Users/pc/Documents/PhD/modelling/ST2/trunk/STST_T1T2trace_100ms.mat;
    setname = '2Target';
    numlags = 8;
    %2 targ: T1 is presented at position 7 (120datapoints/600ms from start of
    %stream - minus baseling is 400ms/80datapnts
    segstart = 80;
    %retina delay is 70ms/14datapnts
    retinadelay = 14;
    numtimepoints = size(ExPostsynBat_basic,3)-(segstart-1);
end

%samprate = numtimepoints/segmtime;
samprate = 200;

numtrials = size(ExPostsynBat_basic,1);
numlayers = size(ExPostsynBat_basic,4);

%add retina delay to vERP traces
%ExPostSyn is trials, lags, timepoints, layers
disp('Adding retina delay to vERP traces..');
numtimepoints = numtimepoints + retinadelay;
PadExPostSyn = zeros(numtrials,numlags,numtimepoints,numlayers);
%no retina delay for input layer
PadExPostSyn(:,:,1:(end-retinadelay),1) = ExPostsynBat_basic(:,1:numlags,segstart:end,1);
%retina delay for other layers
PadExPostSyn(:,:,retinadelay+1:end,2:end) = ExPostsynBat_basic(:,1:numlags,segstart:end,2:end);
%T1 and T2 traces
PadT1ExPostsyn = zeros(numtrials,numlags,numtimepoints,numlayers);
PadT1ExPostsyn(:,:,retinadelay+1:end,:) = T1ExPostsynHistory(:,1:numlags,segstart:end,:);
PadT2ExPostsyn = zeros(numtrials,numlags,numtimepoints,numlayers);
PadT2ExPostsyn(:,:,retinadelay+1:end,:) = T2ExPostsynHistory(:,1:numlags,segstart:end,:);


%vERP channels (dimensions channels, time, trials)
%1 - vP3
%2 - vN2pc
%3 - vSSVEP
%4 - T1P3
%5 - T2P3
%6 - Input
%7 - Binding pool gate

vERP = zeros(7,numtimepoints,numtrials*numlags);

%record the lag trial limits start - end
if study == 2
    laglimits = zeros(8,2);
end

%%%%%%%%%%%%%%%%%%%%%%%%virtual P3 extraction%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('Extracting virtual P3..');
vP3SeparateLags = squeeze(sum(PadExPostSyn(:,:,:,[3 4 6 8]),4));

%vP3 is timepoints, trials
vP3 = zeros(numtimepoints,numtrials*numlags);

if study == 1
    vP3 = permute(vP3SeparateLags,[2 1]);
elseif study == 2
    vP3SeparateLags = permute(vP3SeparateLags,[2 3 1]);
    %reorder vP3 to contain all lags in 2 dimensions
    for lagno = 1 : numlags
        startind = ((lagno-1) * numtrials) + 1;
        endind = lagno * numtrials;
        laglimits(lagno,1) = startind;
        laglimits(lagno,2) = endind;
        vP3(:,startind:endind) = squeeze(vP3SeparateLags(lagno,:,:));
    end
end

%assign to vERP
vERP(1,:,:) = vP3;

%%%%%%%%%%%%%%%%%%%%%%%%virtual N2pc extraction%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('Extracting virtual N2pc..');
vN2pcSeparateLags = squeeze(PadExPostSyn(:,:,:,13));

%vN2pc is timepoints, trials
vN2pc = zeros(numtimepoints,numtrials*numlags);

if study == 1
    vN2pc = permute(vN2pcSeparateLags,[2 1]);
elseif study == 2
    vN2pcSeparateLags = permute(vN2pcSeparateLags,[2 3 1]);
    %reorder vN2pc to contain all lags in 2 dimensions
    for lagno = 1 : numlags
        startind = ((lagno-1) * numtrials) + 1;
        endind = lagno * numtrials;
        laglimits(lagno,1) = startind;
        laglimits(lagno,2) = endind;
        vN2pc(:,startind:endind) = squeeze(vN2pcSeparateLags(lagno,:,:));
    end
end

%assign to vERP
vERP(2,:,:) = vN2pc;

%%%%%%%%%%%%%%%%%%%%%%%%virtual ssVEP extraction%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('Extracting virtual ssVEP..');
vSSVEPSeparateLags = squeeze(sum(PadExPostSyn(:,:,:,[1 2]),4));

%vSSVEP is timepoints, trials
vSSVEP = zeros(numtimepoints,numtrials*numlags);

if study == 1
    vSSVEP = permute(vSSVEPSeparateLags,[2 1]);
elseif study == 2
    vSSVEPSeparateLags = permute(vSSVEPSeparateLags,[2 3 1]);
    %reorder vSSVEP to contain all lags in 2 dimensions
    for lagno = 1 : numlags
        startind = ((lagno-1) * numtrials) + 1;
        endind = lagno * numtrials;
        laglimits(lagno,1) = startind;
        laglimits(lagno,2) = endind;
        vSSVEP(:,startind:endind) = squeeze(vSSVEPSeparateLags(lagno,:,:));
    end
end

%assign to vERP
vERP(3,:,:) = vSSVEP;

%%%%%%%%%%%%%%%%%%%%%%%%T1 P3 extraction%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('Extracting T1 P3..');
T1P3SeparateLags = squeeze(sum(PadT1ExPostsyn(:,:,:,[3 4 6 8]),4));

%T1P3 is timepoints, trials
T1P3 = zeros(numtimepoints,numtrials*numlags);

if study == 1
    T1P3 = permute(T1P3SeparateLags,[2 1]);
elseif study == 2
    T1P3SeparateLags = permute(T1P3SeparateLags,[2 3 1]);
    %reorder vP3 to contain all lags in 2 dimensions
    for lagno = 1 : numlags
        startind = ((lagno-1) * numtrials) + 1;
        endind = lagno * numtrials;
        laglimits(lagno,1) = startind;
        laglimits(lagno,2) = endind;
        T1P3(:,startind:endind) = squeeze(T1P3SeparateLags(lagno,:,:));
    end
end

%assign to vERP
vERP(4,:,:) = T1P3;

%%%%%%%%%%%%%%%%%%%%%%%%T2 P3 extraction%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('Extracting T2 P3..');
T2P3SeparateLags = squeeze(sum(PadT2ExPostsyn(:,:,:,[3 4 6 8]),4));

%T2P3 is timepoints, trials
T2P3 = zeros(numtimepoints,numtrials*numlags);

if study == 1
    T2P3 = permute(T2P3SeparateLags,[2 1]);
elseif study == 2
    T2P3SeparateLags = permute(T2P3SeparateLags,[2 3 1]);
    %reorder vP3 to contain all lags in 2 dimensions
    for lagno = 1 : numlags
        startind = ((lagno-1) * numtrials) + 1;
        endind = lagno * numtrials;
        laglimits(lagno,1) = startind;
        laglimits(lagno,2) = endind;
        T2P3(:,startind:endind) = squeeze(T2P3SeparateLags(lagno,:,:));
    end
end

%assign to vERP
vERP(5,:,:) = T2P3;

%%%%%%%%%%%%%%%%%%%%%%%%Input Activation extraction%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('Extracting Input Activation..');
InputSeparateLags = squeeze(PadExPostSyn(:,:,:,1));

%Input is timepoints, trials
Input = zeros(numtimepoints,numtrials*numlags);

if study == 1
    Input = permute(InputSeparateLags,[2 1]);
elseif study == 2
    InputSeparateLags = permute(InputSeparateLags,[2 3 1]);
    %reorder Input to contain all lags in 2 dimensions
    for lagno = 1 : numlags
        startind = ((lagno-1) * numtrials) + 1;
        endind = lagno * numtrials;
        laglimits(lagno,1) = startind;
        laglimits(lagno,2) = endind;
        Input(:,startind:endind) = squeeze(InputSeparateLags(lagno,:,:));
    end
end

%assign to vERP
vERP(6,:,:) = Input;
%%%%%%%%%%%%%%%%%%%%%%%%Binding pool gate extraction%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('Extracting binding pool gate..');
bindpoolSeparateLags = squeeze(PadExPostSyn(:,:,:,6));

%binding pool gate is timepoints, trials
bindpool = zeros(numtimepoints,numtrials*numlags);

if study == 1
    bindpool = permute(bindpoolSeparateLags,[2 1]);
elseif study == 2
    bindpoolSeparateLags = permute(bindpoolSeparateLags,[2 3 1]);
    %reorder binding pool to contain all lags in 2 dimensions
    for lagno = 1 : numlags
        startind = ((lagno-1) * numtrials) + 1;
        endind = lagno * numtrials;
        laglimits(lagno,1) = startind;
        laglimits(lagno,2) = endind;
        bindpool(:,startind:endind) = squeeze(bindpoolSeparateLags(lagno,:,:));
    end
end

%assign to vERP
vERP(7,:,:) = bindpool;

%%%%%%%%%%%%%%%%%%%%%import vERP into EEGlab%%%%%%%%%%%%%%%%%%%%%%%%%%
[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
disp('Importing vERP to eeglab..');
EEG = pop_importdata( 'dataformat', 'matlab', 'data', vERP, 'setname', setname , 'srate',samprate, 'subject', 'ST2', 'pnts',numtimepoints, 'xmin',-0.2, 'nbchan',size(vERP,1));
[ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );

% %%%%%%%%%%%%%%%%%%%%%add Event markers%%%%%%%%%%%%%%%%%%%%%%%%%%
EEG.event = struct('type',[],'latency',[],'points',[],'description',[],'channelnumber',[],'epoch',[]);
if study == 1
    disp('Adding event markers..');
    %event type contains accuracy, description target strength
    markers = {'MaskCorTarget' '' 'MaskFalsTarget' ''};
    lats = zeros(1,size(EEG.data,3));
    epochs = 1:size(EEG.data,3);
    contlat = eeg_lat2point(lats,epochs,EEG.srate,[EEG.xmin EEG.xmax]);
    for i = 1:size(EEG.data,3)
        markerindex = BasicAccu(i);
        EEG.event(i) = struct('type',markers{markerindex},'latency',contlat(i),'points',1,'description',num2str(T1strength(i)),'channelnumber',0,'epoch',i);
    end
    EEG = eeg_checkset( EEG, 'eventconsistency');
    disp('Saving set with event markers..');
    EEG = pop_saveset( EEG,  'filename', [setname '.set'], 'filepath', '/Users/pc/Documents/PhD/EEG/virtualERPs/');

elseif study == 2
    disp('Adding event markers..');
    %event type contains accuracy, description target strength
    
    %Reorder Accu file
    ReorderAccu = zeros(numtrials*numlags,1);
    ReorderT1strength = zeros(numtrials*numlags,1);
    ReorderT2strength = zeros(numtrials*numlags,1);
    for lagno = 1 : numlags
        startind = ((lagno-1) * numtrials) + 1;
        endind = lagno * numtrials;
        ReorderAccu(startind:endind) = squeeze(BasicAccu(:,lagno));
        ReorderT1strength(startind:endind) = squeeze(T1strength);
        ReorderT2strength(startind:endind) = squeeze(T2strength);
    end
    
    %latencies odd index is T1 - even index is T2
    lats = zeros(1,size(EEG.data,3)*2);
    %epoch array with epoch number per T1 and T2 from lats
    epochs = ceil(.5:.5:size(EEG.data,3));
    
    for i = 1:length(lats)
        %get lag
        for l = 1 : numlags
            if epochs(i) >= laglimits(l,1) && epochs(i) <= laglimits(l,2)
                lag = l;
            end
        end
        if rem(i,2) == 0 %even is a T2 - epochlatency is the lag
            lats(i) = lag * .1;
        else %odd is a T1 - epochlatency is 0
            lats(i) = 0;
        end
    end
    
    %get continuous latencies from epoched latencies
    contlat = eeg_lat2point(lats,epochs,EEG.srate,[EEG.xmin EEG.xmax]);

    for i = 1:2:length(lats)
        %get lag
        for l = 1 : numlags
            if epochs(i) >= laglimits(l,1) && epochs(i) <= laglimits(l,2)
                lag = l;
            end
        end

        lagstr = num2str(lag);
        T1markers = {['CorT1Lag' lagstr 'corT2'] ['CorT1Lag' lagstr 'notT2'] ['FalsT1Lag' lagstr 'corT2'] ['FalsT1Lag' lagstr 'notT2']};
        T2markers = {['CorT2Lag' lagstr 'corT1'] ['FalsT2Lag' lagstr 'corT1'] ['CorT2Lag' lagstr 'notT1'] ['FalsT2Lag' lagstr 'notT1']};

        %name event markers
        markerindex = ReorderAccu(epochs(i));
        
        %T1 marker
        EEG.event(i) = struct('type',T1markers{markerindex},'latency',contlat(i),'points',1,'description',num2str(ReorderT1strength(epochs(i))),'channelnumber',0,'epoch',epochs(i));
        %T2 marker
        EEG.event(i+1) = struct('type',T2markers{markerindex},'latency',contlat(i+1),'points',1,'description',num2str(ReorderT2strength(epochs(i))),'channelnumber',0,'epoch',epochs(i));
    end
    EEG = eeg_checkset( EEG, 'eventconsistency');
    disp('Saving set with event markers..');
    EEG = pop_saveset( EEG,  'filename', [setname '.set'], 'filepath', '/Users/pc/Documents/PhD/EEG/virtualERPs/');
end

clear all;
