% Stiamo modellando un sistema meccanico formato da 2 vagoni di massa
% complessiva pari a 3500 kg (2000 + 1500) connessi da un giunto di 
% accoppiamento (molla e smorzatore).
% Vogliamo proggettare e dimesionare le componenti del sistema in modo
% che possa sopportare una accellerazione massima di 0.5 m/s^2.
% Il giunto di accoppiamento deve poter sopportare una forza motrice 
% impulsiva agente sul vagone posteriore pari a 0.5 * 3500 = 1750 N.
% In particolare occure dimensionare la costante elastica K e la distanza a
% riposo tra i vagoni L, in modo che essi non si tocchino mai.
%
% F_motrice < F_elastica ---> K*L > 1750 N
%
% Con un accellerazione di 0.5 m/s^2, il convoglio dovrebbe essere in grado
% di raggiungere:
% la velocità di 100 km/h in appena 55.5 s.
% la velocità di 200 km/h in appena 1 minuto e 51.1 s.
% la velocità di crociera di 300 km/h in appena 2 minuti e 46.6 s.

%% Punto 1
clc
close all
clear all

m1 = 2000;
m2 = 1500;



%% caso autovalori immaginari puri (0.6831i ; -0,6831i ; 0 ; 0)  |  F_elastica_max = K*L = 2000 N
c = 0;
k = 400;
L = 5;

%% caso autovalori complessi coniugati (-0.2917 + 0.3851i ; -0.8205 - 0.8205i ; 0 ; 0)  |  F_elastica_max = K*L = 1950 N
c = 500;
k = 650;
L = 3;

%% caso autovalori reali e distinti (-1.3020 ; -0.4480 ; 0 ; 0)|  F_elastica_max = K*L = 2000 N
c = 1500;
k = 500;
L = 4;

%% 
A = [0,0,1,0 ; 0,0,0,1 ; -k/m1, k/m1, -c/m1, c/m1 ; k/m2, -k/m2, c/m2, -c/m2];

B = [0 ; 0 ; 1/m1 ; 0];

M = [0 ; 0 ; 0 ; 1/m2]; 

C = [1, 0, 0, 0];

D = 0;

x_0 = [2 ; 3 ; 1 ; 1]; %[pos. primo vagone (relativo al suo zero) ; pos. secondo vagone (relativo al suo zero) ; velocità primo vagone ; velocità secondo vagone]

Pd = C;                                          
    
    for i = 1:1:3                                

        Temp = (C)*(A^i);                                
        Pd = [Pd ; Temp];                                  
    end

Ad = A';
Bd = C';

%% Caso V con autovalori che convergono lentamente
poles = [-2,-3,-4,-5];
K = place(Ad,Bd,poles);
V = transpose(K);
H = A - V*C;
eig(H)

%% Caso V con autovalori che convergono velocemente
poles = [-10,-20,-30,-40];
K = place(Ad,Bd,poles);
V = transpose(K);
H = A - V*C;
eig(H)

%% Caso V progettata come guadagno di un filtro di Kalman
%Q = 1;
%R = 1;
%[K, LV, P] = kalman(ss(A,B,C,D), Q, R);
%V = LV;


% Definizione delle matrici di peso dello stato (Q) e di controllo (R)
q = 1;
Q = q*eye(4);  % Matrice identità 2x2 per penalizzare lo stato
R = 1;  % Matrice identità 1x1 per penalizzare il controllo

% Calcolo della matrice di guadagno del filtro di Kalman
[F, ~, ~] = lqr(A', C', Q, R);

% Utilizzo della matrice di guadagno V come guadagno del terzo osservatore
V = F';


H = A - V*C;
eig(H)

%% Simulazione realistica del convoglio

g1 = 0;     % guadagno moltiplicativo nello schema simulink per l'ingresso sinusoidale
g2 = 1750;  % guadagno moltiplicativo nello schema simulink per l'ingresso a gradino (Forza Motrice sul vagone 1)
g3 = 0;     % guadagno moltiplicativo nello schema simulink per l'ingresso gaussiano
g4 = 0;     % guadagno moltiplicativo nello schema simulink per l'ingresso a distribuzione uniforme
g5 = -100;  % guadagno moltiplicativo nello schema simulink per il disturbo addittivo (Forza Resistiva sul vagone 2 dovuta all'attrito con l'aria)
g6 = 100;   % guadagno moltiplicativo nello schema simulink per l'errore additivo di misura

min_disturbo = 0.95;    % valore minimo per la distrubuzione uniforme che genera il disturbo su simulink
max_disturbo = 1;       % valore massimo per la distrubuzione uniforme che genera il disturbo su simulink

x_0_stimato = [0; 0; 0; 0];

%% Simulazione con valori piccoli

g1 = 0;    % guadagno moltiplicativo nello schema simulink per l'ingresso sinusoidale
g2 = 1;     % guadagno moltiplicativo nello schema simulink per l'ingresso a gradino (Forza Motrice sul vagone 1)
g3 = 0;     % guadagno moltiplicativo nello schema simulink per l'ingresso gaussiano
g4 = 0;     % guadagno moltiplicativo nello schema simulink per l'ingresso a distribuzione uniforme
g5 = 50;     % guadagno moltiplicativo nello schema simulink per il disturbo addittivo (Forza Resistiva sul vagone 2 dovuta all'attrito con l'aria)
g6 = 1;   % guadagno moltiplicativo nello schema simulink per l'errore additivo di misura

min_disturbo = -1;    % valore minimo per la distrubuzione uniforme che genera il disturbo su simulink
max_disturbo = 1;       % valore massimo per la distrubuzione uniforme che genera il disturbo su simulink

x_0_stimato = [1; 2; 0; 0];





%% caso autovalori immaginari puri (0.6831i ; -0,6831i ; 0 ; 0)  |  F_elastica_max = K*L = 2000 N
m1 = 2078; %2000;
m2 = 1463; %1500;
c =  4.6;  %0;
k =  391; %400;
L = 5;

Ar = [0,0,1,0 ; 0,0,0,1 ; -k/m1, k/m1, -c/m1, c/m1 ; k/m2, -k/m2, c/m2, -c/m2];
Br = [0 ; 0 ; 1/m1 ; 0];
Mr = [0 ; 0 ; 0 ; 1/m2]; 
Cr = [1, 0, 0, 0];
Dr = 0;
x_0 = [0 ; 0 ; 0 ; 0];



%% caso autovalori complessi coniugati (-0.2917 + 0.3851i ; -0.8205 - 0.8205i ; 0 ; 0)  |  F_elastica_max = K*L = 1950 N
m1 = 2078; %2000;
m2 = 1463; %1500;
c = 570; %500;
k = 639; %650;
L = 3;

Ar = [0,0,1,0 ; 0,0,0,1 ; -k/m1, k/m1, -c/m1, c/m1 ; k/m2, -k/m2, c/m2, -c/m2];
Br = [0 ; 0 ; 1/m1 ; 0];
Mr = [0 ; 0 ; 0 ; 1/m2]; 
Cr = [1, 0, 0, 0];
Dr = 0;
x_0 = [0 ; 0 ; 0 ; 0];

%% caso autovalori reali e distinti (-1.3020 ; -0.4480 ; 0 ; 0)|  F_elastica_max = K*L = 2000 N
m1 = 2078; %2000;
m2 = 1463; %1500;
c = 1416; %1500;
k = 570; %500;
L = 4;

Ar = [0,0,1,0 ; 0,0,0,1 ; -k/m1, k/m1, -c/m1, c/m1 ; k/m2, -k/m2, c/m2, -c/m2];
Br = [0 ; 0 ; 1/m1 ; 0];
Mr = [0 ; 0 ; 0 ; 1/m2]; 
Cr = [1, 0, 0, 0];
Dr = 0;
x_0 = [0 ; 0 ; 0 ; 0];

