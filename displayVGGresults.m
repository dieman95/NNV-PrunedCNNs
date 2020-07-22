function displayVGGresults(path_to_results)
load(path_to_results);
% Unpruned
disp('============================');
disp('=====  Unpruned Network  ==========');
disp('============================');
disp('Total number of images analyzed = ' + string(n-skN));
disp('Accuracy: ' + string(sum(cor_nn.*anlz)) + '/' + (string(n-skN)) + ' = ' + string(acc_nn));
disp('Robust: ' + string(sum(r_nn==1)));
disp('Unknown: ' + string(sum(r_nn==2)));
disp('Total time: ' + string(sum(tC_nn)) + ' seconds');
disp('Average time per image: ' + string(sum(tC_nn)/(n-skN)) + 'seconds');

% Pruned
disp('============================')
disp('=======  Pruned Network  ==========');
disp('============================')
disp('Total number of images analyzed = ' + string(n-skN));
disp('Accuracy: ' + string(sum(cor_nnP.*anlz)) + '/' + (string(n-skN)) + ' = ' + string(acc_nnP));
disp('Robust: ' + string(sum(r_nnP==1)));
disp('Unknown: ' + string(sum(r_nnP==2)));
disp('Total time: ' + string(sum(tC_nnP)) + ' seconds');
disp('Average time per image: ' + string(sum(tC_nnP)/(n-skN)) + 'seconds');

end

