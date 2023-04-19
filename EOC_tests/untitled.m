offset1 = 305;
offset2 = 125;
offset3 = 127;



data = readtable("raw_data\EOC_Test1_C.csv");
data2 = readtable("raw_data\EOC_Test1_C2.csv");
data3 = readtable("raw_data\EOC_Test1_C3.csv");

% Trim variables:

o2 = data{offset1-20:offset1+60,7};

o22 = data2{offset2-20:offset2+60,7};

o23 = data3{offset3-20:offset3+60,7};

t = linspace(-20,60,81);

plot(t, o2);
hold on
plot(t, o22);
plot(t, o23);