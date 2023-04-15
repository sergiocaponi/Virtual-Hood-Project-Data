% Delimiters:

R0_delimit = [460, 700];
R10_delimit = [840, 1100];
R20_delimit = [1170, 1410];
R30_delimit = [1500, 1740];
R50_delimit = [1840, 2100];


R0_arr = dataset{R0_delimit(1):R0_delimit(2), 2:end};
R10_arr = dataset{R10_delimit(1):R10_delimit(2), 2:end};
R20_arr = dataset{R20_delimit(1):R20_delimit(2), 2:end};
R30_arr = dataset{R30_delimit(1):R30_delimit(2), 2:end};
R50_arr = dataset{R50_delimit(1):R50_delimit(2), 2:end};

R0 = mean(R0_arr);
R10 = mean(R10_arr);
R20 = mean(R20_arr);
R30 = mean(R30_arr);
R50 = mean(R50_arr);

pt_loc = [0; 10; 20; 30; 50];

pt_arr = [R0; R10; R20; R30; R50];
pt_arr = [pt_loc pt_arr];

pt_dataset = array2table(pt_arr);

pt_dataset.Properties.VariableNames = dataset.Properties.VariableNames;

pt_dataset = renamevars(pt_dataset,1, 'Distance');

scatter(pt_dataset,"Distance","T_RP");
hold on
scatter(pt_dataset,"Distance","T_probe");