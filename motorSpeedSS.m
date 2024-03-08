function motorAccel = motorSpeedSS(motorSpeed, Up, Vp, Wp, airDens, P_e, vi0)

dt = 1;

airplane_ic_constants

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
motorAccel = max(min(1/Jp*(Qe-Qp), 100*2*pi),-100*2*pi)^2;