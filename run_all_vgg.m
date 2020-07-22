%% Run all robustness experiments
% VGG 11
cd 'vgg11';
run vgg11robust.m
cd ..;
pause;
% VGG 13
cd 'vgg13';
run vgg13robust.m
cd ..;
pause;
% VGG 16
cd 'vgg16';
run vgg16robust.m
cd ..;
pause;
% VGG 19
cd 'vgg19';
run vgg19robust.m
cd ..;
clc;

%% Display all the results
% VGG11
disp('****************************************');
disp(' ');
disp('Printing VGG11 results');
disp(' ');
displayVGGresults('vgg11/vgg11results');
disp(' ');

% VGG 13
disp('****************************************');
disp(' ');
disp('Printing VGG13 results');
disp(' ');
displayVGGresults('vgg13/vgg13results');
disp(' ');

% VGG 16
disp('****************************************');
disp(' ');
disp('Printing VGG16 results');
disp(' ');
displayVGGresults('vgg16/vgg16results');
disp(' ');

% VGG 19
disp('****************************************');
disp(' ');
disp('Printing VGG19 results');
disp(' ');
displayVGGresults('vgg19/vgg19results');