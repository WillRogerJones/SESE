
function Eval_Visibility(outputfile, erpfile)

clearvars -except outputfile erpfile
% Load data files
load(outputfile);
load(erpfile);

% Close all existing figures
close all

% set size number of trials
siz = 196;

% Generate the set of all components making up the final P3
P3 = squeeze(sum(ExPostsynFull_basic(:,:,:,[3 4 6 8],:),4));
% Generate the T1 component of the P3
T1P3 = squeeze(sum(P3(:,:,:,[1]),4));
% Generate the T2 component of the P3
T2P3 = squeeze(sum(P3(:,:,:,[2]),4));

% Initialise the array of visibility results
vis_array = zeros(siz,8,3);

% Set threshhold for visibility
stre = 0.01;

Cor = zeros(1,8);
All = zeros(1,8);
SwapCount = zeros(1,8);
for j = 1:8
    for i = 1:196
        T1Pos = floor((i-1)/14) + 1;
        T2Pos = mod((i-1), 14)+1;
        T1Val = T1batterydata(1,T1Pos, T2Pos, j);
        T2Val = T2batterydata(1,T1Pos, T2Pos, j);
        switch Swapbatterydata(1,T1Pos, T2Pos, j)
            case 0.5
                Swap = randi(0:1);
            case 1
                Swap = 1;
            otherwise
                Swap = 0;
        end
        Double = doubledata(1,T1Pos, T2Pos, j);
        if T1Val&(~(Swap))
            All(1,j) = All(1,j) + 1;
            vis_array(i,j,1) = sum(squeeze(T1P3(i,j,:)) > stre); % Timesteps T1 is above threshold
            vis_array(i,j,2) = sum(squeeze(T2P3(i,j,:)) > stre & ~(squeeze(T1P3(i,j,:)) > stre)); % Timesteps T2 is above threshold, and T1 is not            
            vis_array(i,j,3) = sum(squeeze(T2P3(i,j,:)) > stre); % Timesteps T2 is above threshold, regardless of T1
        end
        if T1Val&T2Val&(~(Swap))
            Cor(1,j) = Cor(1,j) + 1;
            vis_array(i,j,1) = sum(squeeze(T1P3(i,j,:)) > stre); % Timesteps T1 is above threshold
            vis_array(i,j,2) = sum(squeeze(T2P3(i,j,:)) > stre & ~(squeeze(T1P3(i,j,:)) > stre)); % Timesteps T2 is above threshold, and T1 is not            
            vis_array(i,j,3) = sum(squeeze(T2P3(i,j,:)) > stre); % Timesteps T2 is above threshold, regardless of T1
        end
        if (Swap)
            SwapCount(1,j) = SwapCount(1,j) + 1;
        end

    end
end
SwapCount./Cor


% Statistics about time above threshold

% mean timesteps above threshold
me = squeeze(sum(vis_array(:,:,:),1));
me(:,1) = me(:,1)./(sum(vis_array(:,:,1)~=0,1).');
me(:,2) = me(:,2)./(sum(vis_array(:,:,1)~=0,1).');
me(:,3) = me(:,3)./(sum(vis_array(:,:,3)~=0,1).');
% me
% max timesteps above threshold
ma = squeeze(sum(vis_array(:,:,:),1));
ma(:,1) = (max(vis_array(:,:,1)).');
ma(:,2) = (max(vis_array(:,:,2)).');
ma(:,3) = (max(vis_array(:,:,3)).');
% ma
% min timesteps above threshold
tmpmi = vis_array;
tmpmi(tmpmi==0) = Inf;
mi = squeeze(sum(vis_array(:,:,:),1));
mi(:,1) = (min(tmpmi(:,:,1)).');
mi(:,2) = (min(tmpmi(:,:,2)).');
mi(:,3) = (min(tmpmi(:,:,3)).');
% mi

% Calculate visibility by lag
% Calculation is average timesteps above threshold per trial, normalised by
% maximum visibility
((sum(vis_array(:,:,2),1).')./All')./max(max(ma))

% Calculate T2|T1 accuracy
Cor./All

%gfilt = @(x)gaussfilt(70:320,x,10);
gfilt = @(x)x;
%% Anonymous functions for generating various plots of the P3

% Low visibility P3 vs High Visibility P3
plotVisP3 = @(lo, hi, la, st, ed) plot(st:ed,gfilt(squeeze(sum(sum(P3(find(vis_array(:,la,2) <=lo&vis_array(:,la,1) > 0),la,st:ed,:),4),1)/length(find(vis_array(:,la,2) <=lo &vis_array(:,la,1) > 0)))),st:ed,gfilt(squeeze(sum(sum(P3(find(vis_array(:,la,2) >hi&vis_array(:,la,1) > 0),la,st:ed,:),4),1)/length(find(vis_array(:,la,2) >hi&vis_array(:,la,1) > 0)))));
% Low visibility T1P3 vs High Visibility T1P3
plotVisT1P3 = @(lo, hi, la, st, ed) plot(st:ed,squeeze(sum(sum(T1P3(find(vis_array(:,la,2) <=lo&vis_array(:,la,1) > 0),la,st:ed,:),4),1)/length(find(vis_array(:,la,2) <=lo &vis_array(:,la,1) > 0))),st:ed,squeeze(sum(sum(T1P3(find(vis_array(:,la,2) >hi &vis_array(:,la,1) > 0),la,st:ed,:),4),1)/length(find(vis_array(:,la,2) >hi &vis_array(:,la,1) > 0))));
% Low visibility T2P3 vs High Visibility T2P3
plotVisT2P3 = @(lo, hi, la, st, ed) plot(st:ed,squeeze(sum(sum(T2P3(find(vis_array(:,la,2) <=lo&vis_array(:,la,1) > 0),la,st:ed,:),4),1)/length(find(vis_array(:,la,2) <=lo &vis_array(:,la,1) > 0))),st:ed,squeeze(sum(sum(T2P3(find(vis_array(:,la,2) >hi &vis_array(:,la,1) > 0),la,st:ed,:),4),1)/length(find(vis_array(:,la,2) >hi &vis_array(:,la,1) > 0))));
% Breakdown by component of high vis P3
plotVisAP3 = @(lo, hi, la, st, ed) plot(st:ed,squeeze(sum(P3(find(vis_array(:,la,2) >hi),la,st:ed,:),1)/length(find(vis_array(:,la,2) >hi&vis_array(:,la,1) > 0))));
% Breakdown by component of low vis P3
plotVisBP3 = @(lo, hi, la, st, ed) plot(st:ed,squeeze(sum(P3(find(vis_array(:,la,2) <=lo&vis_array(:,la,1) > 0),la,st:ed,:),1)/length(find(vis_array(:,la,2) <= lo&vis_array(:,la,1) > 0))));

%% Plot figures 

% Set threshholds for high and low visibility. Currently above/below mean.
l = me(1,2);
h = me(1,2);

% Set retinal delay
st = 70;
ed = 320;

% Lag 1 figures
figure;
plotVisP3(l,h,1,st,ed)
xlim([90 330])

figure;
plotVisT1P3(l,h,1,st,ed)
xlim([90 330])

figure;
plotVisT2P3(l,h,1,st,ed)
xlim([90 330])

figure;
plotVisAP3(l,h,1,st,ed)
xlim([90 330])

figure;
plotVisBP3(l,h,1,st,ed)
xlim([90 330])

% Lag 3 figures

% Set threshholds for high and low visibility. Currently above/below mean.
l = ma(3,2)/2;
h = ma(3,2)/2;

figure;
plotVisP3(l,h,3,st,ed)
xlim([90 330])

figure;
plotVisT1P3(l,h,3,st,ed)
xlim([90 330])

figure;
plotVisT2P3(l,h,3,st,ed)
xlim([90 330])

figure;
plotVisAP3(l,h,3,st,ed)
xlim([90 330])

figure;
plotVisBP3(l,h,3,st,ed)
xlim([90 330])



%% Compile time series into a data set
% Data format is dataset, timestamp, value
% Dataset is labeled by two numbers, first number 1-2 is low-high
% visibility, second number 1-4 is lag. E.g. 14 is low visibility lag 4.
% Set retinal delay
st = 70;
ed = 320;


la = 1;
lo = me(1,2);
hi = me(1,2);
data = [repmat(11,ed-st+1,1),(st:ed).',squeeze(sum(sum(P3(find(vis_array(:,la,2) <=lo&vis_array(:,la,1) > 0),la,st:ed,:),4),1)/length(find(vis_array(:,la,2) <=lo &vis_array(:,la,1) > 0)))];
data = [data;repmat(21,ed-st+1,1),(st:ed).',squeeze(sum(sum(P3(find(vis_array(:,la,2) >hi&vis_array(:,la,1) > 0),la,st:ed,:),4),1)/length(find(vis_array(:,la,2) >hi&vis_array(:,la,1) > 0)))];


la = 2;
lo = me(2,2);
hi = me(2,2);
data = [data;repmat(12,ed-st+1,1),(st:ed).',squeeze(sum(sum(P3(find(vis_array(:,la,2) <=lo&vis_array(:,la,1) > 0),la,st:ed,:),4),1)/length(find(vis_array(:,la,2) <=lo &vis_array(:,la,1) > 0)))];
data = [data;repmat(22,ed-st+1,1),(st:ed).',squeeze(sum(sum(P3(find(vis_array(:,la,2) >hi&vis_array(:,la,1) > 0),la,st:ed,:),4),1)/length(find(vis_array(:,la,2) >hi&vis_array(:,la,1) > 0)))];


la = 3;
lo = me(3,2);
hi = me(3,2);
data = [data;repmat(13,ed-st+1,1),(st:ed).',squeeze(sum(sum(P3(find(vis_array(:,la,2) <=lo&vis_array(:,la,1) > 0),la,st:ed,:),4),1)/length(find(vis_array(:,la,2) <=lo &vis_array(:,la,1) > 0)))];
data = [data;repmat(23,ed-st+1,1),(st:ed).',squeeze(sum(sum(P3(find(vis_array(:,la,2) >hi&vis_array(:,la,1) > 0),la,st:ed,:),4),1)/length(find(vis_array(:,la,2) >hi&vis_array(:,la,1) > 0)))];

la = 4;
lo = me(4,2);
hi = me(4,2);
data = [data;repmat(14,ed-st+1,1),(st:ed).',squeeze(sum(sum(P3(find(vis_array(:,la,2) <=lo&vis_array(:,la,1) > 0),la,st:ed,:),4),1)/length(find(vis_array(:,la,2) <=lo &vis_array(:,la,1) > 0)))];
data = [data;repmat(24,ed-st+1,1),(st:ed).',squeeze(sum(sum(P3(find(vis_array(:,la,2) >hi&vis_array(:,la,1) > 0),la,st:ed,:),4),1)/length(find(vis_array(:,la,2) >hi&vis_array(:,la,1) > 0)))];

% Save dataset (warning, these can be LARGE, commented out for now)
save('dataset', 'data')
end

function [zfilt] = gaussfilt(t, z, sigma)
    a = 1/(sqrt(2*pi)*sigma); % scalar on the gaussian distribution to make sure area = 1
    dt = diff(t); % calculate ms per timestep
    dt = dt(1); % calculate ms per timestep
    filter = dt*a*exp(-0.5*((t - mean(t)).^2)/(sigma*sigma)); % create filter
    i = filter < dt*a*1.e-6; % create cutoff point for filter
    filter(i) = []; % set cutoff point for filter
    zfilt = conv(z,filter,'same'); % apply filter to data. Points outside the time series are set to be 0
    %zfilt = cconv(z,filter,length(z)); % apply a circular filter, points
    %outside the time series loop back to the other end
end
