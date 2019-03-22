README

Instructions for executing the Simultaneous Type, Serial Token model as published in
Bowman & Wyble (2007)

---

Core Files

architecture.m - Defines the neural network
inputpatterns.m – Defines the RSVP structure
generateinput.m – Convert an RSVP stream into time steps of input
runRSVP.m – runs a set of RSVP streams for lags 1-8
perfcheck.m - Evaluates performance of the model for a single trial
evaltargs.m – Evaluates performance for a series of trials
Utility files
bigbattery.m – executes a series of trials over values of T1 and T2
showneurons.m – shows the activity of the network.
binderview.m - shows the activity of the binding pool
summatecheck.m - Used to separate recorded neuronal activation by seen/missed
runModel.m – batch file that runs the model using the specified conditions first in 100ms
then 50ms SOA

---

Special Conditions:
To add priming from the T1+1 distractor to T2, uncomment the indicated line (line 274-
283) in architecture.m which will add an excitatory connection in the item layer.
The 50 ms condition involves changes to the RSVP stream, as well as a single parameter
change in architecture (the connection from layer 1 to layer 2 is increased), as specified
in the paper.

---

Running the model:
To run the model, just execute runModel.m which simulates 3 experimental conditions:
basic blink, T1+1 blank, T2+1 blank at 100ms and 50ms SOA. Parameters in this script
determine what conditions are simulated.

NOTE: The research question that provoked the construction of this version dictates that
the model has been extensively run with two targets, no blank and 100ms SOA. This is the
default setting, and while the model should work under other conditions, they have only
been minimally tested - caveat emptor.
 
For a model with a soarate of Xms, results of the simulation are stored in two mat files named 
STSTerp_Xms.mat and STSToutput_Xms.mat.

---

Evaluating Visibility:
To run the visibility calculation and visualise the results, first run the model to get
STSTerp_Xms.mat and STSToutput_Xms.mat. Then run Eval_Visibility on the two files in the
following order:

Eval_Visibility(STSToutput_Xms.mat,STSTerp_Xms.mat)

Note that you may need to specify the full path to both files, depending on how your MATLAB PATH
variable is set up. For example:

Eval_Visibility('C:\MATLAB\STSToutput_100ms.mat','C:\MATLAB\STSTerp_100ms.mat')

