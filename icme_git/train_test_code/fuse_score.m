% This file is used for fuse the 3 trained model (view1, view2, view3)
% for skeleton classification.
% Edited by Huahui Chen, 2017.3.17

clear all

num_output = 27;
final_data_ind = 28880 - 28000;
prob1 = [];
prob2 = [];
prob3 = [];
ground_truth = [];
for i = 1 : num_output
    filedir =  'skeleton_view1/deploy_output/';
    filename = [filedir 'output_view1_' int2str(i) '.h5'];
    temp_ground_truth = h5read(filename, '/label');
    temp_prob =  h5read(filename, '/data');

    [score, ind]=max(temp_prob, [], 3);
    ac1(i) = length(find(ind == temp_ground_truth + 1)) / 1000;    
    
    if(i == num_output)
        prob1 = cat(4, prob1, temp_prob(:, :, :, 1:final_data_ind));
        ground_truth = cat(4, ground_truth, temp_ground_truth(:, :, :, 1:final_data_ind));
    else
        prob1 = cat(4, prob1, temp_prob);
        ground_truth = cat(4, ground_truth, temp_ground_truth);
    end

end

for i = 1 : num_output
    filedir =  'skeleton_view2/deploy_output/';
    filename = [filedir 'output_view2_' int2str(i) '.h5'];
    temp_ground_truth = h5read(filename, '/label');
    temp_prob =  h5read(filename, '/data');

    [score, ind]=max(temp_prob, [], 3);
    ac2(i) = length(find(ind == temp_ground_truth + 1)) / 1000;    
    
    
    if(i == num_output)
        prob2 = cat(4, prob2, temp_prob(:, :, :, 1:final_data_ind));
    else
        prob2 = cat(4, prob2, temp_prob);
    end
end

prob3 = [];
for i = 1 : num_output
    filedir =  'skeleton_view3/deploy_output/';
    filename = [filedir 'output_view3_' int2str(i) '.h5'];
    temp_ground_truth = h5read(filename, '/label');
    temp_prob =  h5read(filename, '/data');

    [score, ind]=max(temp_prob, [], 3);
    ac3(i) = length(find(ind == temp_ground_truth + 1)) / 1000;    
    
    if(i == num_output)
        prob3 = cat(4, prob3, temp_prob(:, :, :, 1:final_data_ind));
    else
        prob3 = cat(4, prob3, temp_prob);
    end

end


% ave fuze
prob_ave = (prob1 + prob2 + prob3) / 3;
[score, ind] = max(prob_ave, [], 3);
ac_ave = length(find(ind == ground_truth + 1)) / size(ind, 4);

% max fuze
prob_max = max(prob1, prob2);
prob_max = max(prob_max, prob3);
[score, ind] = max(prob_max, [], 3);
ac_max = length(find(ind == ground_truth + 1)) / size(ind, 4);

% multiply fuze
prob_mul = prob1 .* prob2 .* prob3;
[score, ind] = max(prob_mul, [], 3);
ac_mul = length(find(ind == ground_truth + 1)) / size(ind, 4);

