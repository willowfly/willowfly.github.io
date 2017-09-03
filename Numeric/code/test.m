close all; clear all ;clc;
syms a b f1 f2 real
K = [0 1 0; 1/f2 0 1; 0.5*(1/f1-1/f2) 1 -1];
f = [a; b-0.5/f2; -0.125*(1/f1-1/f2)];
pretty( simplify(K\f,'steps',1) )
