aoadic = 0;
P_e_ic = 0;
tic

options = optimoptions('fmincon','OptimalityTolerance', 1e-3, 'StepTolerance',0.01, 'Display', 'off'); 
                               % trim_airplane_min(aoadic, P_e_ic, vcaso, hpo, dElevIC, typeError)
[aoatrim1,b,c,out] = fmincon(@(x) trim_airplane_min(x, P_e_ic, vcaso, hpo, 0, 0, 0, 1),aoadic,[],[],[],[],-30,30,[],options);

[dElevTrim,b,c,out] = fmincon(@(x) trim_airplane_min(aoatrim1, P_e_ic, vcaso, hpo, x, 0, 0, 2),0,[],[],[],[],elev_lwr_lim,elev_upr_lim,[],options);

[P_e_trim,b,c,out] = fmincon(@(x) trim_airplane_min(aoatrim1, x, vcaso, hpo, dElevTrim, vcaso/10, 10, 3),min(P_e_max*vcaso/300,P_e_max),[],[],[],[],0,P_e_max,[]);
[aoatrim,b,c,out] = fmincon(@(x) trim_airplane_min(x, P_e_trim, vcaso, hpo, dElevTrim, motorSpeed0, vi0, 1),aoatrim1,[],[],[],[],-30,30,[],options);

options.StepTolerance = 0.01;
[error,Fx,~,Fz,~,My,~] = trim_airplane_min(aoatrim, P_e_trim, vcaso, hpo, dElevTrim, motorSpeed0, vi0, 4);

toc

fprintf('\nAirplane Trimmed:\n');
fprintf(' -- aoatrim = %g\n',aoatrim);
fprintf(' -- dElevTrim = %g\n',dElevTrim);
fprintf(' -- P_e_trim = %g\n',P_e_trim);

fprintf('\nTrim cost: %g\n', error);
fprintf(' -- Fx = %g\n', Fx);
fprintf(' -- Fz = %g\n', Fz);
fprintf(' -- My = %g\n', My);

