function Lorentz_Simulation()

clear; clc; close all;

    % --- 1. PHYSICAL CONSTANTS (SI Units) ---
    q = 1.602e-19;       % Charge of Proton (Coulombs)
    m = 1.67e-27;        % Mass of Proton (kg)
    
    % --- 2. FIELD PARAMETERS ---
    % Magnetic Field (B) in Tesla [Bx; By; Bz]
    % (A strong magnetic field along Z-axis causes cyclotron rotation)
    B_field = [0; 0; 0.1]; 
    
    % Electric Field (E) in Volts/meter [Ex; Ey; Ez]
    % (Adding a small E-field creates a spiral/helix acceleration)
    E_field = [0; 0; 50]; 

    % --- 3. INITIAL CONDITIONS ---
    % Position [x; y; z] (meters)
    r0 = [0; 0; 0];
    
    % Velocity [vx; vy; vz] (m/s)
    % High speed perpendicular to B-field to create rotation
    v0 = [2e5; 0; 1e4]; 
    
    y0 = [r0; v0]; % State vector combining position and velocity

    % --- 4. NUMERICAL INTEGRATION (Runge-Kutta Method) ---
    t_span = [0 5e-6]; % Simulation time (seconds)
    
    % Solving the differential equation using 'ode45'
    options = odeset('RelTol', 1e-6, 'AbsTol', 1e-6);
    [t, Y] = ode45(@(t,y) lorentz_force(t, y, q, m, B_field, E_field), t_span, y0, options);

    % --- 5. VISUALIZATION ---
    figure('Color', 'white', 'Name', 'CERN Project Simulation');
    plot3(Y(:,1), Y(:,2), Y(:,3), 'b-', 'LineWidth', 1.5);
    grid on;
    axis equal;
    
    % Labels and Title
    xlabel('X Position (m)');
    ylabel('Y Position (m)');
    zlabel('Z Position (m)');
    title({'Trajectory of a Proton in Electromagnetic Fields', ...
           'Simulation using Runge-Kutta Method (ode45)'});
    
    % Add Start and End points
    hold on;
    plot3(Y(1,1), Y(1,2), Y(1,3), 'go', 'MarkerFaceColor', 'g', 'MarkerSize', 8); % Start
    plot3(Y(end,1), Y(end,2), Y(end,3), 'ro', 'MarkerFaceColor', 'r', 'MarkerSize', 8); % End
    legend('Trajectory', 'Start', 'End');
    
    disp('Simulation Completed Successfully.');
end

% --- HELPER FUNCTION: THE PHYSICS ENGINE ---
function dydt = lorentz_force(~, y, q, m, B, E)
    % y(1:3) = Position (x,y,z)
    % y(4:6) = Velocity (vx,vy,vz)
    
    v = y(4:6); % Extract velocity vector
    
    % Calculate Lorentz Force: F = q(E + v x B)
    F = q * (E + cross(v, B));
    
    % Newton's Second Law: F = ma -> a = F/m
    a = F / m;
    
    % Output derivative vector [velocity; acceleration]
    dydt = [v; a];
end