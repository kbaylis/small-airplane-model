function motorAccel = findThrust(motorSpeed, Up, Vp, Wp, airDens, P_e)

vi0 = Up;

if vi0 == 0
    vi0 = 0.01;
end

[T, vi, H, motorAccel] = calculateThrustState(Up, Vp, Wp, airDens, motorSpeed, vi0, P_e);