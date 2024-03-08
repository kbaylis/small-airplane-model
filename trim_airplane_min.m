function [error, Fx, Fy, Fz, Mx, My, Mz]  = trim_airplane_min(aoadic, P_e_ic, vcaso, hpo, dElevIC, motorSpeed0_ic, vi0_ic, typeError)
%UNTITLED8 Summary of this function goes here
%   Detailed explanation goes here

airplane_ic_constants;



dt = 0.01;
tf = 0.01;
t = (0:dt:tf)';

N = length(t);
v1 = ones(1,N);

vcas = vcaso*v1;
aoad = aoadic*v1;    % + nose up
betad = 0*v1;   % + nose right
pd = v1*0;
rd = v1*0;
qd = v1*0;
h = v1*hpo;
dAil_R = 0*v1;
dAil_L = 0*v1;
dElev = dElevIC*v1;
dRud = 0*v1;
P_e = P_e_ic*v1;
roll_att = 0*v1;
pitch_att = aoad.*v1;
psid = 0*v1;

airDens = interp1(airDensityBreakpoints, airDensityData,hpo);

if P_e_ic == 0
    motorSpeed0 = 0;
    vi0 = 0;
else
    if typeError <= 2
        motorSpeed0 = motorSpeed0_ic;
        vi0 = vi0_ic;
    else
        motorSpeed0 = fmincon(@(x)motorSpeedSS(x, vcaso*cosd(aoadic), 0, -vcaso*sind(aoadic), airDens, P_e_ic, 10), motorSpeed0_ic);
        vi0 = fsolve(@(x)findVi2(x, vcaso*cosd(aoadic), 0, -vcaso*sind(aoadic), motorSpeed0, airDens), vi0_ic);
    end
end

u = [vcas;
    aoad;
    betad;
    pd;
    rd;
    qd;
    h;
    dAil_R;
    dAil_L;
    dElev;
    dRud;
    P_e;
    roll_att;
    pitch_att;
    psid]';

assignin('base','t',t);
assignin('base','dt',dt);
assignin('base','tf',tf);
assignin('base','u',u);
assignin('base','vi0',vi0);
assignin('base','motorSpeed0',motorSpeed0);

sim('SmallAerobaticAirplaneModel_Simulink')

Fx = logsout.getElement('Fx_airplane').Values.Data(end);
Fy = logsout.getElement('Fy_airplane').Values.Data(end);
Fz = logsout.getElement('Fz_airplane').Values.Data(end);
Mx = logsout.getElement('Mx_airplane').Values.Data(end);
My = logsout.getElement('My_airplane').Values.Data(end);
Mz = logsout.getElement('Mz_airplane').Values.Data(end);

switch typeError
    case 1
        error = Fz^2;
    case 2
        error = My^2;
    case 3
        error = Fx^2;
    case 4
        error = Fz^2 + My^2 + Fx^2;
    otherwise
        error = 0;
end


end

