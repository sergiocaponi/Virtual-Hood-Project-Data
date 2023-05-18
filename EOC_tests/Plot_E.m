%offset1 = 305;
%offset2 = 125;
%offset3 = 127;



data = readtable("raw_data\EOC_Test1_E1.csv");

t = data{:, 2};
o2 = data{:, 7};


% Trim variables:

%o2 = data{offset1-20:offset1+60,7};

%o22 = data2{offset2-20:offset2+60,7};

%o23 = data3{offset3-20:offset3+60,7};

%t = linspace(-20,60,81);

plot(t, o2);
%plot(t, o23);
title('Flow Stop Tests')
xlabel('Time [s]')
ylabel('O_2 concentration [%]')



legend('Test 1', 'Test 2', 'Test 3');