function [F, T] = findVi2(vi, Up, Vp, Wp, motorSpeed, airDens)

    
    propRadius  = 1.1;      % propeller radius [ft]
    A_prop      = 5.9;      % lift-curve slope
    nPropBlades = 2;        % number of blades
    bladeChord  = 0.17;     % blade effective chord
    theta0      = 0.31;     % root blade pitch
    theta1      = -0.21;    % blade twist
    propArea    = propRadius^2*pi;

    % Equation 8.2-6 (find V')
    Vapp = sqrt((Up+vi)^2 + Vp^2 + Wp^2);

    % Equation 8.2-8 - 8.2-10 (find T)
    T = airDens*A_prop*nPropBlades*bladeChord*propRadius/4*( ...
        (Up+vi)*motorSpeed*propRadius + 2/3*(motorSpeed*propRadius)^2* ...
        (theta0 + 3/4*theta1) + (Vp^2 + Wp^2)*(theta0 + 1/2*theta1));

    % Equation 8.2-5
    F = T/(2*airDens*propArea*Vapp) - vi;


    
end

