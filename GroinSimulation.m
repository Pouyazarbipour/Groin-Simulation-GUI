%% POUYA ZARBIPOUR LAKPOSHTEH EMAIL: pouyazarbipour@gmail.com

classdef GroinSimulation < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure               matlab.ui.Figure
        GroinLengthLabel       matlab.ui.control.Label
        GroinLengthEditField   matlab.ui.control.NumericEditField
        WaveAngleLabel         matlab.ui.control.Label
        WaveAngleEditField     matlab.ui.control.NumericEditField
        DiffusivityLabel       matlab.ui.control.Label
        DiffusivityEditField   matlab.ui.control.NumericEditField
        CalculateButton        matlab.ui.control.Button
        StopButton             matlab.ui.control.Button
        UIAxes                 matlab.ui.control.UIAxes
    end

    % Custom properties for calculations
    properties (Access = private)
        StopSimulation logical = false
        Length         double
        WaveAngle      double
        Diffusivity    double
        jstep          double = 0
        dt             double = 86400 % Time step in seconds (1 day)
        TotalLength    double
        Q              double
        xm             double
    end

    % App initialization and construction
    methods (Access = public)
        % Constructor
        function app = GroinSimulation()
            % Create UI and components
            createComponents(app);
        end
    end

    % Callback functions
    methods (Access = private)
        
        % Button press to start calculation
        function calculateButtonCallback(app, ~)
            % Get user inputs
            app.Length = app.GroinLengthEditField.Value;
            app.WaveAngle = deg2rad(app.WaveAngleEditField.Value); % Convert to radians
            app.Diffusivity = app.DiffusivityEditField.Value;

            % Validate inputs
            if isnan(app.Length) || isnan(app.WaveAngle) || isnan(app.Diffusivity)
                uialert(app.UIFigure, 'Enter valid numeric values for all inputs.', 'Input Error');
                return;
            end

            % Disable inputs during simulation
            app.GroinLengthEditField.Enable = 'off';
            app.WaveAngleEditField.Enable = 'off';
            app.DiffusivityEditField.Enable = 'off';
            app.StopSimulation = false;

            % Initialize calculations
            app.jstep = 0;
            app.simulationLoop();
        end

        % Button press to stop simulation
        function stopButtonCallback(app, ~)
            app.StopSimulation = true;
        end

        % Simulation loop
        function simulationLoop(app)
            bypassingTime = (pi * app.Length^2) / (4 * app.Diffusivity * tan(app.WaveAngle)^2);
            totalLength = 6 * sqrt(pi * app.Length^2);
            amplitude = app.UIAxes.Position(4) - 10;

            % Initialize shoreline
            x = linspace(-totalLength / 2, totalLength / 2, 600);
            shoreline = zeros(size(x));

            % Compute constant values
            app.xm = (2.84576 * app.Length) / tan(app.WaveAngle); % Critical distance
            app.TotalLength = totalLength;

            while ~app.StopSimulation
                % Calculate diffusion effects
                fact = sqrt(4 * app.Diffusivity * app.jstep * app.dt);
                scale = amplitude / (2 * app.Length);

                % Update Q (sediment transport rate)
                app.Q = tan(app.WaveAngle) * app.Diffusivity * app.jstep * app.dt;

                for i = 1:length(x)
                    xi = x(i);
                    shoreline(i) = scale * ((fact / sqrt(pi)) * exp(-xi^2 / fact^2) ...
                        - xi * (1 - erf(xi / fact))) * tan(app.WaveAngle);
                end

                % Stop simulation if bypassing occurs
                if app.jstep * app.dt > bypassingTime
                    app.StopSimulation = true;
                    break;
                else
                    app.jstep = app.jstep + 1;
                end

                % Plot results
                plot(app.UIAxes, x, shoreline, 'b', 'LineWidth', 2);
                hold(app.UIAxes, 'on');
                plot(app.UIAxes, [0 0], [0 amplitude], 'k--'); % Groin line

                % Add text annotations for Q and xm
                text(app.UIAxes, -app.TotalLength / 2, amplitude - 20, ...
                    sprintf('Q = %.2f m^2/day', app.Q), 'FontSize', 12, 'Color', 'r');
                text(app.UIAxes, -app.TotalLength / 2, amplitude - 70, ...
                    sprintf('x_m = %.2f m', app.xm), 'FontSize', 12, 'Color', 'r');

                title(app.UIAxes, sprintf('Day: %d', app.jstep));
                xlabel(app.UIAxes, 'Distance (m)');
                ylabel(app.UIAxes, 'Shoreline Elevation (m)');
                hold(app.UIAxes, 'off');
                pause(0.15);
            end

            % Re-enable inputs after simulation
            app.GroinLengthEditField.Enable = 'on';
            app.WaveAngleEditField.Enable = 'on';
            app.DiffusivityEditField.Enable = 'on';
        end
    end

    % Create UI components
    methods (Access = private)
        
        function createComponents(app)
            % Create UIFigure
            app.UIFigure = uifigure('Position', [100, 100, 800, 600]);
            app.UIFigure.Name = 'Groin Simulation';

            % Create input fields
            app.GroinLengthLabel = uilabel(app.UIFigure, 'Position', [50, 550, 150, 22], 'Text', 'Groin Length (m):');
            app.GroinLengthEditField = uieditfield(app.UIFigure, 'numeric', 'Position', [200, 550, 100, 22], 'Value', 200);

            app.WaveAngleLabel = uilabel(app.UIFigure, 'Position', [50, 500, 150, 22], 'Text', 'Breaking Wave Angle (°):');
            app.WaveAngleEditField = uieditfield(app.UIFigure, 'numeric', 'Position', [200, 500, 100, 22], 'Value', 20);

            app.DiffusivityLabel = uilabel(app.UIFigure, 'Position', [50, 450, 150, 22], 'Text', 'Shoreline Diffusivity (m²/s):');
            app.DiffusivityEditField = uieditfield(app.UIFigure, 'numeric', 'Position', [200, 450, 100, 22], 'Value', 0.001);

            % Create buttons
            app.CalculateButton = uibutton(app.UIFigure, 'push', ...
                'Position', [50, 400, 100, 22], 'Text', 'Calculate', ...
                'ButtonPushedFcn', @(btn, event) app.calculateButtonCallback());
            
            app.StopButton = uibutton(app.UIFigure, 'push', ...
                'Position', [200, 400, 100, 22], 'Text', 'Stop', ...
                'ButtonPushedFcn', @(btn, event) app.stopButtonCallback());

            % Create plot axes
            app.UIAxes = uiaxes(app.UIFigure, 'Position', [350, 100, 400, 400]);
            app.UIAxes.Title.String = 'Shoreline Evolution';
            app.UIAxes.XLabel.String = 'Distance (m)';
            app.UIAxes.YLabel.String = 'Elevation (m)';
        end
    end
end
