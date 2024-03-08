airplane_ic_constants



vi0_ic = 10;

ic_zeros = zeros(length(powerBreakpoints_eng), length(airDensityBreakPoints_eng), length(casBreakpoints_eng), length(angleBreakPoints_eng));
engine_tables.T = ic_zeros;
engine_tables.H = ic_zeros;
engine_tables.vi = ic_zeros;
engine_tables.motorSpeed = ic_zeros;
engine_tables.motorAccel = ic_zeros;
engine_tables.Qe = ic_zeros;
engine_tables.Qp = ic_zeros;

for iP = 2:length(powerBreakpoints_eng)
    P_e_ic = powerBreakpoints_eng(iP);
    tic

    for iD =1:length(airDensityBreakPoints_eng)
        airDens = airDensityBreakPoints_eng(iD);

        for iV=1:length(casBreakpoints_eng)
            vcaso = casBreakpoints_eng(iV);

            for iA = 1:length(angleBreakPoints_eng)
                aoadic = angleBreakPoints_eng(iA);

                if iV~=1 || iA==1
                    betadic = 0;
                    Up = vcaso*cosd(aoadic)*cosd(betadic);
                    Vp = vcaso*cosd(aoadic)*(-sind(betadic));
                    Wp = vcaso*cosd(betadic)*sind(aoadic);

                    motorSpeed0 = fmincon(@(x)motorSpeedSS(x, Up, Vp, Wp, airDens, P_e_ic, vi0_ic), max(vcaso/10,10));
                    vi0 = fsolve(@(x)findVi2(x, vcaso*cosd(aoadic), 0, -vcaso*sind(aoadic), motorSpeed0, airDens), vi0_ic);
                    [T, vi, Hy, Hz, motorSpeedOut, motorAccel, Qe, Qp] = calculateThrustState(Up, Vp, Wp, airDens, motorSpeed0, vi0, P_e_ic, .01);
                end
                engine_tables.T(iP, iD, iV, iA) = T;
                engine_tables.H(iP, iD, iV, iA) = -Hz*sign(Wp);
                engine_tables.vi(iP, iD, iV, iA) = vi;
                engine_tables.motorSpeed(iP, iD, iV, iA) = motorSpeedOut;
                engine_tables.motorAccel(iP, iD, iV, iA) = motorAccel;
                engine_tables.Qe(iP, iD, iV, iA) = Qe;
                engine_tables.Qp(iP, iD, iV, iA) = Qp;
                
            end
        end
    end
    toc
end

save('engine_tables.mat','engine_tables');