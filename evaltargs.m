function evaltargs
%Using targvals, which is computed in perfcheck.m  (called by runRSVP) we
%check to see if the target is seen and compute the swaps

global T1perf T2perf Swapencoding
global NUMSTREAMS OutHistory
global doubleencoding targvals
global summate summateacc summatecount summateflag summateflag2 summate2 summateacc2 summatecount2

T1perf = zeros(NUMSTREAMS,1);
T2perf = zeros(NUMSTREAMS,1);
Swapencoding = zeros(NUMSTREAMS,1);
doubleencoding = zeros(NUMSTREAMS,1);

for(i = 1:NUMSTREAMS)
    T1perf(i) = max(targvals(i,:,1));
    T2perf(i) = max(targvals(i,:,2));
    if(T1perf(i) & T2perf(i))
        %compute Swaps
        %an unknown case, order is 50/50
        if(max(abs(targvals(i,:,1) - targvals(i,:,2))) == 0)
            Swapencoding(i,1) = .5;
        end
        % a definite swap
        if(targvals(i,2,2) ==0 & targvals(i,2,1) > 0&targvals(i,3,2) ==0)
            Swapencoding(i,1) = 1;
        end
        %doubles are duplicate encodings of a single target
        if(targvals(i,1,1) & targvals(i,2,1) & ~targvals(i,2,2))
            doubleencoding(i) = 1;
        end
        if(~targvals(i,2,1) & targvals(i,2,2) & targvals(i,3,2))
            doubleencoding(i) = 1;
        end
    end
end

%store activation traces for correct T2s
if(summateflag)
    for(lag = 1:NUMSTREAMS)
        T2perf(lag);
        if(T2perf(lag) > 0)
            'seen';
            summatecount(lag) = summatecount(lag) +1;
            summate(summatecount(lag),lag,:,:,:) = squeeze(OutHistory(lag,:,[4 7 9],1:2));
%             summateacc(summatecount(lag),1) = T1perf(3);
%             summateacc(summatecount(lag),2) = T2perf(3);
        else
            'missed';
            summatecount2(lag) = summatecount2(lag) +1;
            summate2(summatecount2(lag),lag,:,:,:) = squeeze(OutHistory(lag,:,[4 7 9],1:2));
%             summateacc2(summatecount2(lag),1) = T1perf(3);
%             summateacc2(summatecount2(lag),2) = T2perf(3);
        end
    end
end
