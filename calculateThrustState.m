function [T, vi, Hy, Hz, motorSpeedOut, motorAccel, Qe, Qp] = calculateThrustState(Up, Vp, Wp, airDens, motorSpeed, vi0, P_e, dt)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

    Cd0_prop         = 0.01;     % effective zero lift drag coeff
    propRadius  = 1.1;      % propeller radius [ft]
    A_prop      = 5.9;      % lift-curve slope
    nPropBlades = 2;        % number of blades
    bladeChord  = 0.17;     % blade effective chord
    theta0      = 0.31;     % root blade pitch
    theta1      = -0.21;    % blade twist
    Jp          = 0.002;    % inertia of rotor about spin axis
    
    if vi0 == 0
        vi0 = 0.001;
    end
    
    vi = fsolve(@(x)findVi2(x, Up, Vp, Wp, motorSpeed, airDens), vi0);
    [~, T] = findVi(vi, Up, Vp, Wp, motorSpeed, airDens);
    
    % propeller power from rotor thrust
    P_induced = T*(vi+Up);  
    
    % Profile Power - skin friction drag of the prop blades
    P_profile = airDens*Cd0_prop*nPropBlades*bladeChord*motorSpeed*propRadius^2/8 ...
        * ( (motorSpeed*propRadius)^2 + Vp^2 + Wp^2);       
    
    % Calculate Prop Torque
    if (motorSpeed~=0)
        Qp = 1/motorSpeed*(P_induced + P_profile); 
    else
        Qp = 0;  motorSpeed = .001; 
    end
    
    % Calculate Motor torque
    Qe = P_e/motorSpeed;
    
    % Calculate Motor Speed Change - TODO: consider carrying this state
    % through model
    if abs(Qe-Qp)>0.05
        motorAccel = max(min(1/Jp*(Qe-Qp), 10*2*pi),-10*2*pi);
    else
        motorAccel = 0;
    end
    motorSpeedOut = motorSpeed + motorAccel*dt;
    
    % Normal force - force acting on prop perpendicular to trhust within
    % plane containing both thrust and relative velocity vector (8.2-19) pg
    % 637
    if sqrt(Vp^2 + Wp^2)>0
        H = airDens*Cd0_prop*nPropBlades*bladeChord*motorSpeed*propRadius^2/4* ...
            sqrt(Vp^2 + Wp^2);
        Hy = -H*Vp/sqrt(Vp^2 + Wp^2);
        Hz = -H*Wp/sqrt(Vp^2 + Wp^2);
    else
        Hy = 0;
        Hz = 0;
    end
    

end

