# MATLAB HS13 – Research Plan

> * Group Name: Honeybee
> * Group participants names: Gugler Stefan, Huwyler Elias, Tschopp Fabian
> * Project Title: Hive Simulation

## General Introduction
Bees are essential insects for pollination and are therefore directly linked to our food supply.
The pollination rate is directly linked to the health and size of a hive.
Therefore it is important to know under what conditions a hive can grow and how much it takes for a colony to extinct.
Most research done about bees has been experimental so far and there are numerous parameters to take into account.

## The Model
Bees are a very complex social system. This means it is not possible to take all aspects into account.
Some aspects won't be used at all, while others are simplified with probability variables from real world measurements [1].
Our first approach is based largely on an existing simulation which works with a dynamic system and continuous update inside the hive [2].
A reasonable update rate for this is one to a few hours. Simulation length is from a few months to a few years (simulated time).
Parameters and variables taken from the existing simulation[2]:
1. Brood rate  
2. Adult bee emerging  
3. Rate of change of foragers  
4. Recruitment of foragers  
5. Rate of change in food stores  
6. Total hive weight (depending on 5.)  
7. Indicators for hive healthiness (depending on 1. and 5.)  
8. Forager mortality  
9. Sudden events (increased death rate, infections)  

The second approach adds a (graphically represented) environment simulation to refine the simulation.
This will mainly affect parameters 8. and 5. of the first approach by substituting the fixed rates with
values obtained by fine-grained environment simulation (time resolution of approx. one second per iteration step and one day per trigger).
Environment simulation depends on parameters 1. to 9. of the first model and significant changes in those parameters trigger
a re-evaluation of the environment to redefine parameters 8. and 5.

This hybrid approach seems to be a good model because fixed rates [2] are too abstract for such a complex model [1], but evaluating
all parameters and aspects gets too complicated for meaningful statistical analysis.

## Fundamental Questions
Basic questions:  
- Statistical analysis of the existing model assuming fixed rates  
- Hive survival probability over years under different initial conditions  
- Hive growth rate and healthiness  

Advanced questions:  
- The effect of smog on food supply  
- The effect of smog on forager bees (higher death rate)  
- Hive growth and relation to food availability (seasonal changes, different environment configurations)  
- Changes observed between hive-only and hive with environment simulation (population dynamics dependent on environment)  

## Expected Results
It is expected that our simulation will at least reach similar results as the dataset from the reference paper used [2].
This answers our basic questions. It is also expected that using a dynamic environment will give similar results for the
total weight of the hive as found in our reference book [1].

## References 
[1]		Seeley, T. 1995. The wisdom of the hive - the social physiology of honey bee colonies  
[2]		Khoury et al. 2013. Modelling Food and Population Dynamics in Honey Bee Colonies  
[3]		Karaboga, D. 2005. An idea based on honey bee swarm for numerical optimization  
[4]		Girling, R. 2013. Diesel exhaust rapidly degrades floral odours used by honeybees  

## Research Methods
The bees in the environment outside the hive are simulated with an agent-based model (continuously updated). The environment itself (outside the hive), in which
the bees will navigate, is based on a 2D-cellular automaton which is updated sequentially with fixed borders (scent and smog diffusion, flower growth).
Inside the hive, a simplified model is used, assuming all parameters at first and including the parameters of the environment simulation later.
Dynamical systems (SIR Model, ageing and reproduction rate, Lotka-Volterra equations) are used inside the hive.

## Other
Datasets for comparison and model refinement:  
- Experimental data from measurements [1]  
- Simulation data from already existing simulation [2]  
- Advanced parameter datasets for scent and smog [4]  
