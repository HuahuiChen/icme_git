% 
% close all
% clc
% clear
% % addpath('G:\skeleton\detection\detection utl1');
% 
% dir_name = '/home/chh/icme/data/detection/PKU_Skeleton_Renew/';
% 
% resize_height = 100;
% resize_width = 1000;
% 
% 
% obj_name = '/home/chh/icme/data/detection/map_data/train_total/';
% list_name = importdata('/home/chh/icme/data/detection/train_total.txt');
% parfor i = 1 : length(list_name)
%     i
%     name = list_name{i};
%     name=[name,'.txt'];
%     filename = [dir_name,name];
%     img = create_map(filename, resize_height, resize_width);
%     name=name(1:6);
% %     d=[obj_name,name];
%     imwrite(img,[obj_name,name,'.png']);    
% end
% 
% 
% 
% obj_name = '/home/chh/icme/data/detection/map_data/test_total/';
% list_name = importdata('/home/chh/icme/data/detection/test_total.txt');
% parfor i = 1 : length(list_name)
%     i
%     name = list_name{i};
%     name=[name,'.txt'];
%     filename = [dir_name,name];
%     img = create_map(filename, resize_height, resize_width);
%     name=name(1:6);
% %     d=[obj_name,name];
%     imwrite(img,[obj_name,name,'.png']);    
% end
% 
% 
% % 
% % obj_name = '/home/chh/icme/data/detection/map_data/train_cs/';
% % list_name = importdata('/home/chh/icme/data/detection/train-cross-subject.txt');
% % parfor i = 1 : length(list_name)
% %     i
% %     name = list_name{i};
% %     name=[name,'.txt'];
% %     filename = [dir_name,name];
% %     img = create_map(filename, resize_height, resize_width);
% %     name=name(1:6);
% % %     d=[obj_name,name];
% %     imwrite(img,[obj_name,name,'.png']);    
% % end
% % 
% % 
% % obj_name = '/home/chh/icme/data/detection/map_data/test_cs/';
% % list_name = importdata('/home/chh/icme/data/detection/test-cross-subject.txt');
% % parfor i = 1 : length(list_name)
% %     i
% %     name = list_name{i};
% %     name=[name,'.txt'];
% %     filename = [dir_name,name];
% %     img = create_map(filename, resize_height, resize_width);
% %     name=name(1:6);
% % %     d=[obj_name,name];
% %     imwrite(img,[obj_name,name,'.png']);    
% % end





% create submit image
close all
clc
clear
% addpath('G:\skeleton\detection\detection utl1');

dir_name = '/home/chh/icme/data/detection/PKU_Skeleton_Renew/';

resize_height = 100;
resize_width = 4000;


train_obj_name = '/home/chh/icme/data/detection/map_data/train_cs/';

list_name = importdata('/home/chh/icme/data/detection/train-cross-subject.txt');
parfor i = 1 : length(list_name)
    i
    name = list_name{i};
    name=[name,'.txt'];
    filename = [dir_name,name];
    img = create_map(filename, resize_height, resize_width);
    name=name(1:6);
%     d=[obj_name,name];
    imwrite(img,[train_obj_name,name,'.png']);    
end

test_obj_name = '/home/chh/icme/data/detection/map_data/test_cs/';
list_name = importdata('/home/chh/icme/data/detection/test-cross-subject.txt');
parfor i = 1 : length(list_name)
    i
    name = list_name{i};
    name=[name,'.txt'];
    filename = [dir_name,name];
    img = create_map(filename, resize_height, resize_width);
    name=name(1:6);
%     d=[obj_name,name];
    imwrite(img,[test_obj_name,name,'.png']);    
end