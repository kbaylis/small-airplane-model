function [Udot, Wdot, Vdot, pddot, rddot, qddot, dphid, dthetad, dpsid, POSXdot, POSYdot, Hdot] = ForceToDeriv(Fx, Fy, Fz, Mx, My, Mz, U, V, W, pd, rd, qd, phid, psid, thetad, mass)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

Jx = 0.32;
Jy = 1.5;
Jz = 2.3;

D2R = pi/180;

PHI = phid*D2R;
PSI = psid*D2R;
THETA = thetad*D2R;

P = pd*D2R;
R = rd*D2R;
Q = qd*D2R;

Udot = R*V - Q*W + Fx/mass;
Vdot = P*W - R*U + Fy/mass;
Wdot = Q*U - P*V + Fz/mass;

Pdot = (Mx + (Jy-Jz)*R*Q) / Jx;
Rdot = (My + (Jz-Jx)*P*Q) / Jy;
Qdot = (Mz + (Jx-Jy)*R*P) / Jz;

PHIdot = P + Q*sin(PHI)*tan(THETA) + cos(PHI)*tan(THETA);
THETAdot = Q*cos(PHI) - R*sin(PHI);
PSIdot = ( Q*sin(PHI) - R*cos(PHI) ) / min(0.001,cos(THETA));

Te2b = [cos(PSI)*cos(PHI),                              sin(PSI)*cos(PHI),                              -sin(PHI);
        cos(PSI)*sin(THETA)*sin(PHI)-sin(PSI)*cos(PHI), sin(PSI)*sin(THETA)*sin(PHI)+cos(PSI)*cos(PHI), cos(THETA)*sin(PHI);
        cos(PSI)*sin(THETA)*cos(PHI)-sin(PSI)*sin(PHI), sin(PSI)*sin(THETA)*cos(PHI)+cos(PSI)*sin(PHI), cos(THETA)*cos(PHI)];

POSdot = [U, V, W]*Te2b;

pddot = Pdot/D2R;
rddot = Rdot/D2R;
qddot = Qdot/D2R;

dphid = PHIdot/D2R;
dthetad = THETAdot/D2R;
dpsid = PSIdot/D2R;

POSXdot = POSdot(1);
POSYdot = POSdot(2);
Hdot = -POSdot(3);



end

