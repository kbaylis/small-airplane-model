% Mass Properties
weight  = 29;       % [lb]
mass    = weight/32.17;     % [slug]
Jx      = 0.32;     % X-axis inertia, [slug-ft^2]
Jy      = 1.5;      % Y-axis inertia, [slug-ft^2]
Jz      = 2.3;      % Z-axis inertia, [slug-ft^2]

% Constant Wing Parameters
S       = 13.0;     % wing area [ft^2]
Aw      = 4.6;      % lift-curve slope
CL0_w   = 0;        % lift coeff at zero AOA
CLmax_w = 1.1;      % max lift coeff
CLmix_w = -1.1;     % min lift coeff
CD0_w   = 0.01;     % zero lift drag coeff of wing
Kw      = 0.060;    % induced drag ceff of wing
CDfp_w  = 1;        % drag coeff at 90deg AOA
dAil_lim= 0.44;     % aileron deflection limit +/-
tauAil  = 0.4;      % flap effectiveness of ailerons
Nw      = 0.3;      % effect of prop wash on wing
Xw      = 0.2;      % effective center, body X-direction
Yw      = 2.0;      % effective center, body Y-direction
Zw      = 0;        % effective center, body Z-direction
ail_lwr_lim = -25.2; % aileron deflection lower limit [deg]
ail_upr_lim = 25.2; % aileron deflection upper limit [deg]

% Constant Horizontal Tail Params
n_ht    = 1.6;          % effect of prop downwash on horz tail
n_w_ht  = 2.0;          % effect of wing downwash wash on tail
elev_lwr_lim = -17.2;   % elevator deflection limit [deg]
elev_upr_lim = 17.2;    % elevator deflection limit [deg]
tauElev = 0.5;          % flap effectiveness of elevator
Xht     = -3.5;         % effective center, body X-direction
Yht     = 0;            % effective center, body Y-direction
Zht     = 0;            % effective center, body Z-direction
S_ht    = 3.0;      % horz tail area [ft^2]
A_ht    = 3.6;      % lift-curve slope
CL0_ht  = 0;        % lift coeff at zero AOA
CLmax_ht= 1.1;      % max lift coeff
CLmin_ht= -1.1;     % max lift coeff
CD0_ht  = 0.01;     % zero lift drag coeff of horz tail
K_ht    = 0.080;    % induced drag ceff of horz tail
CDfp_ht = 1;        % drag coeff at 90deg AOA

% Constant Horizontal Tail Params
n_vt    = 1.6;          % effect of prop downwash on horz tail
rud_lwr_lim = -28.65;   % elevator deflection limit [deg]
rud_upr_lim = 28.65;    % elevator deflection limit [deg]
tauRud = 0.7;          % flap effectiveness of elevator
Xvt     = -4.1;         % effective center, body X-direction
Yvt     = 0;            % effective center, body Y-direction
Zvt     = -0.60;           % effective center, body Z-direction
S_vt    = 1.3;      % horz tail area [ft^2]
A_vt    = 2.5;      % lift-curve slope
CL0_vt  = 0;        % lift coeff at zero AOA
CLmax_vt= 1.1;      % max lift coeff
CLmin_vt= -1.1;     % max lift coeff
CD0_vt  = 0.01;     % zero lift drag coeff of horz tail
K_vt    = 0.084;    % induced drag ceff of horz tail
CDfp_vt = 1;        % drag coeff at 90deg AOA

% Constant Fuselage Params
Xfuse_uu = 0.15;    % X-axis force coeff [ft^2]
Yfuse_vv = 1.2;     % Y-axis force coeff [ft^2]
Zfuse_ww = 1.0;     % Z-axis force coeff [ft^2]
Xfuse    = -1.5;    % Effective center, body X-dir [ft]
Zfuse    = 0;       % Effective center, body Z-dir [ft]

% Constant Engine/Propeller Params
% Engine
P_e_max_hp = 9.8*0.9;   % 90% of rated 9.8 hp [hp]
P_e_max = P_e_max_hp*550; % engine power [lb-ft/s]
maxEngSpeed = 1000;     % Engine speed at best power [rad/s]
% Propeller
propRadius  = 1.1;      % propeller radius [ft]
A_prop      = 5.9;      % lift-curve slope
nPropBlades = 2;        % number of blades
bladeChord  = 0.17;     % blade effective chord
Cd0_prop    = 0.01;     % effective zero lift drag coeff
theta0      = 0.31;     % root blade pitch
theta1      = -0.21;    % blade twist
Jp = 2;                 % inertia of rotor about spin axis
Xp = 2.2;               % location, body X-direction [ft]
Zp = 0;                 % location, body Z-direction [ft]


airDensityBreakpoints = (-5:5:40)*10^3; % altitude [ft]
airDensityData = [27.45, 23.77, 20.48, 17.56, 14.96, 12.67, 10.66, 8.91, 7.38, 5.87]*10^(-4);  % air density [slugs/ft^3]
casBreakpoints_eng = 0:50:300;
angleBreakPoints_eng = [0:1.5:3, 5:5:15, 30:30:90];
powerBreakpoints_eng = linspace(0, P_e_max, 4);
airDensityBreakPoints_eng = linspace(0.0006, 0.0027, 4);
load engine_tables

linAOAmax  = CLmax_w/Aw;   % maximum AOA for linear increase

