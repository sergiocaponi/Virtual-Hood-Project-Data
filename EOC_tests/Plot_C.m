offset1 = 305;
offset2 = 125;
offset3 = 127;



data = readtable("raw_data\EOC_Test1_C.csv");
data2 = readtable("raw_data\EOC_Test1_C2.csv");
data3 = readtable("raw_data\EOC_Test1_C3.csv");

t = data{:, 2};
o2 = data{:, 7};

t2 = data2{:, 2};
o22 = data2{:, 7};

t3 = data3{:, 2};
o23 = data3{:, 7};

% Trim variables:

o2 = data{offset1-20:offset1+60,7};

o22 = data2{offset2-20:offset2+60,7};

o23 = data3{offset3-20:offset3+60,7};

t = linspace(-20,60,81);


f = figure;

plot(t, o2, LineWidth=0.8);
hold on
plot(t, o22, LineWidth=0.8);
plot(t, o23, LineWidth=0.8);
title('Full Response Tests')
xlabel('Time [s]')
ylabel('O_2 concentration [%]')

xline(-5,'-', 'Nitrogen Closed')
xline(0,'-', 'Air Opened')

legend('Test 1 (4.5 minutes)', 'Test 2 (1.5 minutes)', 'Test 3 (1.5 minutes)');

fontsize(f, "scale", 1.2);
