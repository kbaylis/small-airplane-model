% m*xddot = -cd*xdot - k*x + f(t)
% X = [x; xdot]

% x'    = xdot;
% xdot' = u/m;
% y = x;


% xdot' = (U(S)-Y(S))*Kp + s*Y(S)*Kd = u*Kp - x*Kp - xdot*Kd

a = fileparts(mfilename('fullpath'))

Kp = 5;
Kd = 7;

m = 11;

A = [ 0 1; -Kp/m -Kd/m];
A2 = [0 1; 0 0];

[V,D] = eig(A)

B = [0; Kp/m];
C = [1, 0];
D = 0;

[num,den] = ss2tf(A2, B, C, D)

H2 = tf(num,den)

% m*xddot = - K * x - C * xdot

G = tf([Kd, Kp], 1)


A = [0 1; -Kp/M -Kd/M];