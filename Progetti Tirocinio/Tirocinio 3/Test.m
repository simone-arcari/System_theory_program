
%%Punto 1
clc
close all
clear all

m1 = 2000;
m2 = 1500;

%% caso autovalori immaginari puri (0.5916i ; -0,5916i ; 0 ; 0)
k = 300;
c = 0;

%% caso autovalori complessi coniugati (-0.2917 + 0.3851i ; -0.2917 - 0.3851i ; 0 ; 0)
c = 500;
k = 200;

%% caso autovalori reali e distinti (-0.4552 ; -0.1282 ; 0 ; 0)
c = 500;
k = 50;

%% 
A = [0,0,1,0 ; 0,0,0,1 ; -k/m1, k/m1, -c/m1, c/m1 ; k/m2, -k/m2, c/m2, -c/m2];

B = [0 ; 0 ; 1/m1 ; 0];

M = [0 ; 0 ; 0 ; 1/m2];

C = [1, 0, 0, 0];

D = 0;

Pd = C;                                          
    
    for i = 1:1:3                                

        Temp = (C)*(A^i);                                
        Pd = [Pd ; Temp];                                  
    end

Ad = A';
Bd = C';

%% Caso Autovalori che convergono lentamente
poles = [-1,-2,-3,-4];
K = place(Ad,Bd,poles);
V = transpose(K);
H = A - V*C;
eig(H)

%% Caso Autovalori che convergono velocemente
poles = [-10,-20,-30,-40];
K = place(Ad,Bd,poles);
V = transpose(K);
H = A - V*C;
eig(H)

%% Caso V progettata come guadagno di un filtro di Kalman
Q = 0;
R = 0;
[K, P, E] = kalman(ss(A, B, C, D), Q, R);
V = transpose(K);
H = A - V*C;
eig(H)

%% Simulazione sistema




