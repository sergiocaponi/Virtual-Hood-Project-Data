clearvars; close all; clc; instrreset

%This programme runs a test in the Cone
%This code is plagiarised with permission from Dr Rory Hadden
%%%% NOTES %%%
% - the DPT span is from manufacurers data sheet - this should be checked.
% - the time between readings is ~1.3 s.
% - delay times are not considered.
% - the RH probe is assumed to follow manufacturer data (is the hard coded data correct?).
% - HRR calculations do not do any pre-ignition averaging (this is for flexibility).
% - there is perhaps some efficinecy to be gained by having the variables as structures e.g. all the temperatures as T.xxx, concentrations as C.xxx, maybe later...
% - T_stack is for next to DPT measurement, T_smoke is for next to LASER measurement.
% - you need to write a separate programme to do proper HRR calculations.
% - all data are saved as a .mat file at the end and a .txt in every loop


% Tell matlab the format for the timestamp - required for keeping track of things
TimeStampFormat = 'yyyymmddHHMMSS.FFF';
%give a filename for your data. The timestamp should prevent any overwriting
FileName = inputdlg('Filename', 'Filename', [1 35], {[datestr(now, TimeStampFormat) '_Virtual Hood Data']});
FileName = [cell2mat(FileName)];

%a=datestr(now, TimeStampFormat)
%b=str2double(datetime("now",'Format','yyyyMMDDHHmmss.ms'))


% AGILENT -cone
% Connect
v34980A = visadev('USB0::0x0957::0x0507::MY56482584::0::INSTR');
%v34980A.InputBufferSize = 8388608; v34980A.ByteOrder = 'little-endian';
writeline(v34980A,'*RST'); writeline(v34980A,'*CLS');
% Housekeeping
set(v34980A,'timeout',2)
CONE_CHANNELS_TC = '1026:1030';TCs=5;
CONE_CHANNELS_VDC = '6001, 6003';VOLTAGES=2;

writeline(v34980A, sprintf(':FORMat:READing:CHANnel %d', 1));
writeline(v34980A, sprintf(':FORMat:READing:ALARm %d', 1));
writeline(v34980A, sprintf(':FORMat:READing:UNIT %d', 1));
writeline(v34980A, sprintf(':FORMat:READing:TIME:TYPE %s', 'REL'));

writeline(v34980A,sprintf(['CONF:VOLT:DC (@' CONE_CHANNELS_VDC ')']));             % Configure the specified channels for dc or ac voltage measurements but do not initiate the scan. Note that this command also redefines the scan list. The range is 10V and the resolution 1PLC (3E-5 or 5 1/2 Digits or 20 Bits)
writeline(v34980A,sprintf(['SENS:RES:APER 1,(@' CONE_CHANNELS_VDC ')']));

%fprintf(v34980A, sprintf(['CONF:VDC, (@' ScanList_Pres ')']));
%fprintf(v34980A, sprintf(['SENS:RES:APER, 1, (@' ScanList_Pres ')']));

% writeline(v34970A,sprintf(['CONF:VOLT:DC 10  ,0.001   ,(@' HOOD_CHANNELS_VDC ')']));        % Configure the specified channels for dc or ac voltage measurements but do not initiate the scan. Note that this command also redefines the scan list. The rage is 10V and the resolution 1PLC (3E-5 or 5 1/2 Digits or 20 Bits)

writeline(v34980A,sprintf(['CONF:TEMP TC, K,(@' CONE_CHANNELS_TC ')']));                      % Configure the specified channels for thermocouple measurements but do not initiate the scan. Note that this command also redefines the scan list. The default (DEF) transducer type is a J-Type thermocouple.
writeline(v34980A,sprintf(['UNIT:TEMP C,(@' CONE_CHANNELS_TC ')']));                          % Select the temperature measurement units on the specified channels. The default is “C”. The :TEMP? query returns the temperature measurement units currently selected. Returns “C”, “F”, or “K”.
writeline(v34980A,sprintf(['SENS:TEMP:TRAN:TYPE TC,(@' CONE_CHANNELS_TC ')']));               % Select the type of temperature transducer to use for measurements on the specified channels. Select from TC (thermocouple), RTD (2-wire RTD), FRTD (4-wire RTD), or THER (thermistor) . The default is TC. The :TYPE? query returns the current temperature transducer type on the specified channels. Returns “TC”, “RTD”, “FRTD”, or “THER”.
writeline(v34980A,sprintf(['SENS:TEMP:TRAN:TC:TYPE K,(@' CONE_CHANNELS_TC ')']));             % Select the thermocouple type to use on the specified channels. The default is a J-Type thermocouple. The :TYPE? query returns the thermocouple type currently in use. Returns “B”, “E”, “J”, “K”, “N”, “R”, “S”, or “T”.
writeline(v34980A,sprintf(['SENS:TEMP:TRAN:TC:CHEC OFF,(@' CONE_CHANNELS_TC ')']));           % Disable or enable the thermocouple check feature to verify that your thermocouples are properly connected to the screw terminals for measurements. If you enable this feature, the instrument measures the channel resistance after each thermocouple measurement to ensure a proper connection. If an open connection is detected (greater than 5 k? on the 10 k? range), the instrument reports an overload condition for that channel. The default is “OFF”. The :CHEC? query returns the thermocouple check setting. Returns “0” (OFF) or “1” (ON).
writeline(v34980A,sprintf(['SENS:TEMP:TRAN:TC:RJUN:TYPE INT,(@' CONE_CHANNELS_TC ')']));


writeline(v34980A,sprintf(['ROUT:SCAN (@' CONE_CHANNELS_TC ',' CONE_CHANNELS_VDC ')']));




% call the function that does the fitting requred from the calibration
[O2_fit, CO_fit, CO2_fit, DPT_fit, APT_fit, RH_fit] = vdc2eng_units(FileName);

%figure to plot the data and add some commands for the user - this is set up so the system keeps logging until you hit the stop button. Always end with this so the code closes the instruments and you dont have to use tmtool to manually do that
test_fig = figure('units', 'normalized', 'position', [0.125 0.125 0.75 0.75]);
% the buttons and their callback functions. MATLAB does not recommend using strings as the callbacks but rather to use functions. Trouble is passing the info between the handles and the function :(. A bit of a hack but it works
ignition_button = uicontrol('Style', 'Pushbutton', 'String', 'Ignition', 'fontsize', 16, 'BackgroundColor',[0.8 0.8 0.8], 'units', 'normalized', 'Position', [0.15 0.03 0.1 0.07],'Callback', 'ignition_time(i) = str2num(datestr(now, TimeStampFormat));ignition_row(i) = i;');
event_button = uicontrol('Style', 'Pushbutton', 'String', 'Event', 'fontsize', 16, 'BackgroundColor',[0.8 0.8 0.8], 'units', 'normalized', 'Position', [0.35 0.03 0.1 0.07],'Callback', 'event_time(i) = str2num(datestr(now, TimeStampFormat));event_row(i) = i;');
flameout_button = uicontrol('Style', 'Pushbutton', 'String', 'Flame out', 'fontsize', 16, 'BackgroundColor',[0.8 0.8 0.8], 'units', 'normalized', 'Position', [0.55 0.03 0.1 0.07],'Callback', 'flameout_time(i) = str2num(datestr(now, TimeStampFormat));flameout_row(i) = i;');
stop_button = uicontrol('Style', 'Pushbutton', 'String', 'Stop', 'fontsize', 16, 'BackgroundColor',[0.8 0.8 0.8], 'units', 'normalized', 'Position', [0.75 0.03 0.1 0.07],  'Callback', 'logging = 0;');
%prepare the axes in a nice way by calling the function prepare_axes (its at the end of the script)
[O2_axes, DPT_axes, CO2_axes, CO_axes, mass_axes, HRR_axes, temp1_axes] = prepare_axes(test_fig);

i = 1; %cos a counter is needed to index the variables
v_duct = 0; X0_O2_A = 0; X0_CO_A = 0; X0_CO2_A = 0; Q_OC__O2_CO2_CO = 0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% This is where the magic (DATA LOGGING) happens %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
logging=1;
while(logging==1) %loop runs until you press STOP
    tic
    %************************ Read Analyser Data *************************%
    cone_data_as_text = writeread(v34980A, 'READ?');

    data_as_num = str2num(cone_data_as_text);
    readings = data_as_num([(TCs+1):(TCs+VOLTAGES)]);
    temps = data_as_num(1:TCs);
    %TC_Temps(i,:) = data_as_num(12:15);

    v_data(i,:) = (readings); %make a variable that is a matrix of all the channels
    temperatures(i,:) = (temps); %same with the temps
    timestamp(i) = str2double(datestr(now, TimeStampFormat))'; %get a timestamp to associate with the data
    test_time(i) = (datenum(num2str(timestamp(i), '%.3f'), TimeStampFormat)-datenum(num2str(timestamp(1), '%.3f'), TimeStampFormat)).*(24*60*60);

    %************************ Convert Raw to Eng *************************%
    DPT(i)=(v_data(i,1)-6)*3.125;


% 
%     %*************************** Calculate HRR ***************************%
%     [Q_OC__O2_CO2_CO, v_duct, X0_O2_A, X0_CO_A, X0_CO2_A] = HRR_calc(i, conc_CO, conc_CO2, conc_O2, T_ambient, T_duct, RH_ambient, DPT_Pa, APT_kPa, v_duct, X0_O2_A, X0_CO_A, X0_CO2_A, Q_OC__O2_CO2_CO);

    %**************************** Plot Graphs ****************************%
    %plot_O2 = plot(test_time, conc_O2, 'parent', O2_axes, 'color', 'b');
    %plot_CO = plot(test_time, conc_CO, 'parent', CO_axes, 'color', [0.7 0.7 0.7]);
    %plot_CO2 = plot(test_time, conc_CO2, 'parent', CO2_axes, 'color', [0.8500 0.3250 0.0980]);
    plot_DPT = plot(test_time, DPT, 'parent', DPT_axes, 'color', 'k');
    %plot_HRR = plot(test_time, Q_OC__O2_CO2_CO, 'parent', HRR_axes, 'color', 'r');
    %plot_mass = plot(test_time, mass, 'parent', mass_axes, 'color', 'b');
    plot_temp1 = plot(test_time(:), temperatures(:,:), 'parent', temp1_axes);%, 'color', 'g');
    %plot_temp2 = plot(test_time(:), TC_Temps(:,18:22), 'parent', temp2_axes);%, 'color', 'r');
    %plot_temp3 = plot(test_time(:), TC_Temps(:,23:27), 'parent', temp3_axes);%, 'color', 'k');
    %plot_temp4 = plot(test_time(:),TC_Temps(:,1:12), 'parent', temp4_axes);%, 'color', 'k');

    %O2_axes.YLabel.String = 'O_2 Concentration, %';
    %CO_axes.YLabel.String = 'CO Concentration, ppm';
    %CO2_axes.YLabel.String = 'CO_2 Concentration, %';
    DPT_axes.YLabel.String = 'Pressure Transducer, Pa';
    %HRR_axes.YLabel.String = 'HRR (O2, CO2, CO), kW';
    %mass_axes.YLabel.String = 'Mass, kg';
    temp1_axes.YLabel.String = 'Temperature, C';%'CO Concentration, ppm';
    %temp2_axes.YLabel.String = 'Temperature, C';%'CO Concentration, ppm';
    %temp3_axes.YLabel.String = 'Temperature, C';%'CO Concentration, ppm';
    %temp4_axes.YLabel.String = 'Temperature, C';%'CO Concentration, ppm';

    %O2_axes.XLabel.String = 'Time, s';
    %CO_axes.XLabel.String = 'Time, s';
    %CO2_axes.XLabel.String = 'Time, s';
    DPT_axes.XLabel.String = 'Time, s';
    %HRR_axes.XLabel.String = 'Time, s';
    %mass_axes.XLabel.String = 'Time, s';
    temp1_axes.XLabel.String = 'Time, s';
    %temp2_axes.XLabel.String = 'Time, s';
    %temp3_axes.XLabel.String = 'Time, s';
    %temp4_axes.XLabel.String = 'Time, s';


    %***************************** Save Data *****************************%

    ENG_data(i,:) = [timestamp(i) test_time(i) v_data(i,:) temperatures(i,:) test_time(i)];

    writematrix(ENG_data, [FileName '.txt']);

    disp('----------------------------------------');
    disp(['Test time = ',num2str(test_time(i)),' s.']);
    disp(['The current O2 inlet temperature is ', num2str(temperatures(i,1)), ' C.'])
    disp(['The current internal temperature is ', num2str(temperatures(i,4)), ' C.'])

    i = i+1; %add one to the counting variable whch is used in indexing
    toc
    pause(15.1) %if there isnt a pause you cant click the buttons (hacky hack...)
    %toc
end


%save the variables
%save([FileName '.mat'])%, '-append')
%Close and delete the objects
clear v34980A;
clear loadcell








% THESE ARE THE FUNCTIONS CALLED EARLIER TO KEEP THE CODE FROM LOOKING TOO UGLY

% function to create the axes
function [O2_axes, DPT_axes, CO2_axes, CO_axes, mass_axes, HRR_axes, temp1_axes] = prepare_axes(test_fig)
    O2_axes = axes('Parent', test_fig, 'Position',[0.1 0.72 0.25 0.23], 'box', 'on');
    CO_axes = axes('Parent', test_fig, 'Position',[0.4 0.72 0.25 0.23], 'box', 'on');
    CO2_axes = axes('Parent', test_fig, 'Position',[0.7 0.72 0.25 0.23], 'box', 'on');
    DPT_axes = axes('Parent', test_fig, 'Position',[0.1 0.44 0.25 0.23], 'box', 'on', 'ylim',([0,inf]));
    HRR_axes = axes('Parent', test_fig, 'Position',[0.1 0.16 0.25 0.23], 'box', 'on', 'ylim',([0,inf]));
    mass_axes = axes('Parent', test_fig, 'Position',[0.4 0.16 0.25 0.23], 'box', 'on');
    temp1_axes = axes('Parent', test_fig, 'Position',[0.7 0.16 0.25 0.23], 'box', 'on');
    %temp2_axes = axes('Parent', test_fig, 'Position',[0.3 0.75 0.2 0.2], 'box', 'on');
    %temp3_axes = axes('Parent', test_fig, 'Position',[0.55 0.75 0.2 0.2], 'box', 'on');
    %temp4_axes = axes('Parent', test_fig, 'Position',[0.8 0.75 0.2 0.2], 'box', 'on');
end

% function to deal with the conversion between volts and engineerng units
function [O2_fit, CO_fit, CO2_fit, DPT_fit, APT_fit, RH_fit] = vdc2eng_units(~)
    %load HOOD_CALIBRATION_DATA.mat
    O2_calib_V = [0.0110 5]; O2_zero_span = [0 25];
    CO_calib_V = [0.0360 5]; CO_zero_span = [0 1000];
    CO2_calib_V = [0.0119 5]; CO2_zero_span = [0 4];
    DPT_calib_V = [1.9889 9.9889]; DPT_zero_span = [0 250]; % possibly [2 10]V
    APT_calib_V = [0.0981 5.0017]; APT_zero_span = [80.59 110.01];
    RH_calib_V = [0 5]; RH_zero_span = [0 100];
    
    O2_fit = polyfit(O2_calib_V, O2_zero_span, 1);
    CO_fit = polyfit(CO_calib_V, CO_zero_span, 1);
    CO2_fit = polyfit(CO2_calib_V, CO2_zero_span, 1);
    DPT_fit = polyfit(DPT_calib_V, DPT_zero_span, 1);
    APT_fit = polyfit(APT_calib_V, APT_zero_span, 1);
    RH_fit = polyfit(RH_calib_V, RH_zero_span, 1);
    %save(FileName, 'O2_calib_V', 'CO_calib_V', 'CO2_calib_V', 'DPT_calib_V', 'O2_zero_span', 'CO_zero_span', 'CO2_zero_span', 'DPT_zero_span');
end


function [Q_OC__O2_CO2_CO, v_duct, X0_O2_A, X0_CO_A, X0_CO2_A] = HRR_calc(i, conc_CO, conc_CO2, conc_O2, T_ambient, T_duct, RH_ambient, DPT_kPa, APT_kPa, v_duct, X0_O2_A, X0_CO_A, X0_CO2_A,Q_OC__O2_CO2_CO)
%%% MOST OF THE INDEXING HERE CAN GO! %%%%

% Define constants needed for HRR calcs
%MW of species
M_air = 28.8; M_H2O = 18; M_CO = 28; M_CO2 = 44; M_N2 = 28; M_O2 = 32; M_Soot = 12; M_CH4 = 16; % Molecular weight of dry air [kg/kmol]
% universal constants
R = 8.314472; p_ambient = 101325; %Pa
% energy constants
E_O2 = 13.1; E_CO2 = 13.3; E_CO = 17.6;
E_CO_CO2 = 17.63 * 1000; % assumed to be the energy release from CO->CO2
E_S = 12.3 * 1000;  % 12.3E3[MJ/kg]  Energy release per mass unit of oxygen consumed for combustion of soot to CO2 [kJ/kg]
Delta_H_CO = 283000/28/1000 * 1000; % 2.83E5[kJ/mole] or 10.11 [MJ/kg] Energy release per unit mass of CO consumed in the burning of CO [kJ/mole] Ref.VI
Delta_H_S = 393500/12/1000 * 1000;
% Calorimetry specific constants
alpha = 1.105;

% Apparatus constants
C = 0.0401; % orifice plate constant
Dia_Duct = 0.11; % m
Area_Duct = pi * (Dia_Duct^2) / 4;

% Duct flow calculation
f_Re = 1.08;
rho_e(i) = (353.*(APT_kPa(i).*1000)/101000)./T_duct(i);

%m_duct(i) = 26.54.*Area_Duct.*K./f_Re.*(DPT_Pa(i)./T_duct(i)).^(1/2); %eq 5. (mcafffery probe)
m_duct(i) = C .* sqrt(DPT_kPa(i)./T_duct(i)); %orifice plate
v_duct(i) = m_duct(i)./rho_e(i).*1000;

% Mole fractions &c
X_CO_A(i) = conc_CO(i) ./ 10^6;   %(from ppm to Xratio)
X_CO2_A(i) = conc_CO2(i) ./ 10^3; %(from % to Xratio)
X_O2_A(i) = conc_O2(i) ./ 100;    %(from % to Xratio)

p_H2O_saturation(i) = exp(23.2 - 3816 ./ (-46 + T_ambient(i)));
X0_H2O(i) = RH_ambient(i) .* p_H2O_saturation(i) ./ 100 ./ (APT_kPa(i).*1000);   % The molar fraction of water vapor Equation (10) Ref.I

%X_Soot = 0;
%X_H2O(i) = X0_H2O(i);
%X_O2(i)  = X_O2_A(i)  .* (1 - X_H2O(i) - X_Soot);                                         % Molar fraction of oxygen in the exhaust duct from Equation (18) Ref.III
%X_CO(i)  = X_CO_A(i)  .* (1 - X_H2O(i) - X_Soot);                                         % Molar fraction of carbon monoxide in the exhaust duct from Equation (18) Ref.III
%X_CO2(i) = X_CO2_A(i) .* (1 - X_H2O(i) - X_Soot);

% the ambinet mole fractions are taken to be the first reading to avoidhaving to average
if i==1
    X0_O2_A = X_O2_A(1);
    X0_CO2_A = X_CO2_A(1);
    X0_CO_A = X_CO_A(1);
else
end
%commented since we dont calculate a pre ignition average
% X0_O2_A = mean(X_O2_A(1:t_ignition_row-1));
% X0_CO2_A = mean(X_CO2_A(1:t_ignition_row-1));
% X0_CO_A = mean(X_CO_A(1:t_ignition_row-1));
% disp(['The mole fraction of O2 at the start is ' num2str(X0_O2_A)])
% disp(['The mole fraction of CO2 at the start is ' num2str(X0_CO2_A)])
% disp(['The mole fraction of CO at the start is ' num2str(X0_CO_A)])
% disp(['The vapour pressure of water is ' num2str(X0_CO_A)])

% depletion factors and associated stuff

% if O2 CO2 and CO are measured
PHI_O2_CO2_CO(i) = (X0_O2_A .* (1 - X_CO2_A(i) - X_CO_A(i)) - ...                    % Equation (20) Ref.I
    X_O2_A(i) .* (1 - X0_CO2_A)) ./ ...
    (X0_O2_A .* (1 - X_O2_A(i) - X_CO2_A(i) - X_CO_A(i)));

m_incoming_air(i) = m_duct(i) ./ (1 + PHI_O2_CO2_CO(i) .* (alpha - 1));             % Mass flow rate of the incomming air [kg/s] Equation (15) Ref.I
M_incoming_air(i) = M_air * (1 - X0_H2O(i)) + M_H2O * X0_H2O(i);                % Molecular weight of the incomming air [kg/kmol] which should be around 29 Equation (11) Ref.I

% Heat relase by Oxygen Consumption Calorimetry when O2, CO2 and CO are
% measured. From Janssens, M.L. and Parker, W.J. 1992. "Oxygen Consumption Calorimetry,"in Heat Release in Fires, edited by V. Babrauskas and S.J. Grayson,Chapter 3: pp. 31-59.

Q_OC__O2_CO2_CO(i) = ((E_O2 .* PHI_O2_CO2_CO(i) - (E_CO - E_O2) .* (1-PHI_O2_CO2_CO(i)) ./ 2 .* X_CO_A(i) ./ X_O2_A(i)) .* ...
    m_incoming_air(i) ./ M_incoming_air(i) .*  M_O2 .* (1 - X0_H2O(i)) * X0_O2_A)*1000;

end
