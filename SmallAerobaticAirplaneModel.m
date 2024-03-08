close all;

airplane_ic_constants

trimAirplane = false;
aoatrim= 0;
betatrim=0;
dElevTrim=0;
P_e_trim = 50;

vcaso = 100;
hpo = 1000;
if trimAirplane
    trim_airplane;
    trimAirplane = false;
end

dt = 0.05;
tf = 3;
t = (0:dt:tf)';

N = length(t);
v1 = ones(1,N);

vcas = vcaso*v1.*t';
aoad = aoatrim*v1;    % + nose up
betad = 0*v1;   % + nose right
pd = v1*0;
rd = v1*0;
qd = v1*0;
h = hpo*v1;
dAil_R = 0*v1;
dAil_L = 0*v1;
dElev = dElevTrim*v1;
dRud = 0*v1;
P_e = P_e_trim*v1;
phid = 0*v1;
thetad = aoad.*v1;
psid = 0*v1;


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
    phid;
    thetad;
    psid]';


% Trim params
if ~exist('motorSpeed0','var')
    motorSpeed0 = 0;
end
if ~exist('vi0','var')
    vi0 = vcas(1);
end


sim('SmallAerobaticAirplaneModel_Simulink')

for i=1:logsout.numElements
    sig = logsout.getElement(i);
    
    if contains(sig.BlockPath.getBlock(1),'Wing Model')
        if contains(sig.BlockPath.getBlock(1),'Right')
            sName = [sig.Name, '_rw'];
        elseif contains(sig.BlockPath.getBlock(1),'Left')
            sName = [sig.Name, '_lw'];
        else
            sName = sig.Name;
        end
    else
        sName = sig.Name;
    end

    if ~isempty(sName)
        dat.(sName) = sig.Values;
    end
end


plotAil = false;
plotRud = false;
plotElev = false;
plotFuse = false;
plotProp = false;
plotAccels = true;


sigs = {'Fx_airplane', 'Fy_airplane','Fz_airplane','Mx_airplane','My_airplane','Mz_airplane'};
nSig = length(sigs);

figure;
for i = 1:nSig
    
    subplot(ceil(nSig/2),2,i)
    plot(dat.(sigs{i}).Time, dat.(sigs{i}).Data)
    title(sigs{i}, 'Interpreter', 'none');

end

%% Aileron Plots
if plotAil

    sigs = {'dAil_L', 'dAil_R', 'AOA_wing_lw','AOA_wing_rw'};
    
    nSig = length(sigs);

    figure;
    for i = 1:nSig

        subplot(ceil(nSig/2),2,i)
        plot(dat.(sigs{i}).Time, dat.(sigs{i}).Data)
        title(sigs{i}, 'Interpreter', 'none');

    end

    sigs = {'Fx_wings', 'Fy_wings','Fz_wings','Mx_wings','My_wings','Mz_wings'};
    nSig = length(sigs);

    figure;
    for i = 1:nSig

        subplot(ceil(nSig/2),2,i)
        plot(dat.(sigs{i}).Time, dat.(sigs{i}).Data)
        title(sigs{i}, 'Interpreter', 'none');

    end
    
        sigs = {'D_wing_lw', 'L_wing_lw','D_wing_rw','L_wing_rw'};
    nSig = length(sigs);

    figure;
    for i = 1:nSig

        subplot(ceil(nSig/2),2,i)
        plot(dat.(sigs{i}).Time, dat.(sigs{i}).Data)
        title(sigs{i}, 'Interpreter', 'none');

    end
    sigs = {'AOA_wing_lw', 'AOA_wing_rw'};
    nSig = length(sigs);

    figure;
    for i = 1:nSig

        subplot(ceil(nSig/2),2,i)
        plot(dat.(sigs{i}).Time, dat.(sigs{i}).Data)
        title(sigs{i}, 'Interpreter', 'none');

    end
end

%% Horizontal Tail Plots

if plotElev
    sigs = {'Fx_ht', 'Fy_ht','Fz_ht','Mx_ht','My_ht','Mz_ht'};
    nSig = length(sigs);

    figure;
    for i = 1:nSig

        subplot(ceil(nSig/2),2,i)
        plot(dat.(sigs{i}).Time, dat.(sigs{i}).Data)
        title(sigs{i}, 'Interpreter', 'none');

    end
    % 
    sigs = {'Uht', 'Vht','Wht','AOA_ht'};
    nSig = length(sigs);

    figure;
    for i = 1:nSig

        subplot(ceil(nSig/2),2,i)
        plot(dat.(sigs{i}).Time, dat.(sigs{i}).Data)
        title(sigs{i}, 'Interpreter', 'none');

    end
   
end

if plotRud
    sig_list{1} = {'Fx_vt', 'Fy_vt','Fz_vt','Mx_vt','My_vt','Mz_vt'};
    
    for j=1:numel(sig_list)
        sigs = sig_list{j};
        nSig = length(sigs);

        figure;
        for i = 1:nSig

            subplot(ceil(nSig/2),2,i)
            plot(dat.(sigs{i}).Time, dat.(sigs{i}).Data)
            title(sigs{i}, 'Interpreter', 'none');

        end
    end
    
end

if plotFuse
    sig_list{1} = {'Fx_fuse', 'Fy_fuse','Fz_fuse','Mx_fuse','My_fuse','Mz_fuse'};
    
    for j=1:numel(sig_list)
        sigs = sig_list{j};
        nSig = length(sigs);

        figure;
        for i = 1:nSig

            subplot(ceil(nSig/2),2,i)
            plot(dat.(sigs{i}).Time, dat.(sigs{i}).Data)
            title(sigs{i}, 'Interpreter', 'none');

        end
    end
    
end

if plotProp
    sig_list{1} = {'Fx_p', 'Fy_p', 'Fz_p', 'Mx_p', 'My_p','Mz_p'};
    sig_list{2} = {'motorAccel', 'motorSpeed', 'Qe', 'Qp', 'vi','Fx_p'};
    
    for j=1:numel(sig_list)
        sigs = sig_list{j};
        nSig = length(sigs);

        figure;
        for i = 1:nSig

            subplot(ceil(nSig/2),2,i)
            plot(dat.(sigs{i}).Time, dat.(sigs{i}).Data)
            title(sigs{i}, 'Interpreter', 'none');

        end
    end
    
end

if plotAccels
    clear sig_list
    sig_list{1} = {'Udot', 'Vdot', 'Wdot'};
    
    for j=1:numel(sig_list)
        sigs = sig_list{j};
        nSig = length(sigs);

        figure;
        for i = 1:nSig

            subplot(ceil(nSig/2),2,i)
            plot(dat.(sigs{i}).Time, dat.(sigs{i}).Data)
            title(sigs{i}, 'Interpreter', 'none');

        end
    end
end

toc


