# MATLAB HS13 – Research Plan

> * Group Name: Honeybee
> * Group participants names: Gugler Stefan, Huwyler Elias, Tschopp Fabian
> * Project Title: Hive Simulation

## General Introduction

(States your motivation clearly: why is it important / interesting to solve this problem?)
(Add real-world examples, if any)
(Put the problem into a historical context, from what does it originate? Are there already some proposed solutions?)

## The Model

(Define dependent and independent variables you want to study. Say how you want to measure them.) (Why is your model a good abtraction of the problem you want to study?) (Are you capturing all the relevant aspects of the problem?)


## Fundamental Questions

(At the end of the project you want to find the answer to these questions)
(Formulate a few, clear questions. Articulate them in sub-questions, from the more general to the more specific. )


## Expected Results

(What are the answers to the above questions that you expect to find before starting your research?)


## References 
[1]		Seeley, T. 1995. The wisdom of the hive - the social physiology of honey bee colonies  
[2]		Khoury et al. 2013. Modelling Food and Population Dynamics in Honey Bee Colonies  
[3]		Karaboga, D. 2005. An idea based on honey bee swarm for numerical optimization  
[4]		Girling, R. 2013. Diesel exhaust rapidly degrades floral odours used by honeybees  

(Add the bibliographic references you intend to use)
(Explain possible extension to the above models)
(Code / Projects Reports of the previous year)


## Research Methods
The bees in the environment outside the hive are simulated with an agent-based model (continuously updated). The environment itself (outside the hive), in which
the bees will navigate, is based on a 2D-cellular automaton which is updated sequentially with fixed borders (scent and smog diffusion, flower growth).
Inside the hive, a simplified model is used, assuming all parameters at first and including the parameters of the environment simulation later.
Dynamical systems (SIR Model, aging and reproduction rate) is used inside the hive.

## Other

(mention datasets you are going to use)
