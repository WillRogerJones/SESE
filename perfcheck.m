function perfcheck(lag)
%for a given trial, check to see if the binders and tokens are active

global NUMWM Neurons NUMTARGS NUMBINDERS
global Weightparams Weightindex binders targvals

for(t = 1:NUMWM)
    binders = 0;
    for(b = 1:NUMBINDERS)
        if(~Weightindex(8,6,t,b))
            if(binders == 0)
                binders = b;
            else
                binders = [binders b];
            end
        end
    end

    %targvals(Lag, Token, Target)

    %IF there is a weight between this binder and the target we are
    %checking then check to see if both this binder AND its token have
    %active trace nodes

    %If those nodes are active (above .5), then the corresponding target has been
    %encoded
    %The trace neurons are self-sustaining, so by the end of the trial they
    %are either on or off.

    for(b=binders)
        for(targ= 1:NUMTARGS)
            w =Weightindex(4,6,targ,b) ;
            if(w)
                if(Neurons(7,b)> .5 & Neurons(9,t) > .5)
                    targvals(lag,t,targ) = targvals(lag,t,targ) + Weightparams(w,5);
                end
            end
        end
    end
end


