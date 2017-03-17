% Project skeleton to different planes. This code contains body encode and direction encode.
% size of image is [view_num, 256, 256, 3].
% Edited by Huahui Chen, 2017.3.13
function image = proj_skeleton(bodyinfor)
image_size = [255 255 255];
image = ones(3, 256, 256, 3);
min_x = 100;
max_x = -100;
min_y = 100;
max_y = -100;
min_z = 100;
max_z = -100;
for frame = 1 : length(bodyinfor)
    for body = 1 : length(bodyinfor(frame).bodies)
        for joint = 1 : 25
            if bodyinfor(frame).bodies(body).joints(joint).x < min_x
                min_x = bodyinfor(frame).bodies(body).joints(joint).x;
            end
            if  bodyinfor(frame).bodies(body).joints(joint).x > max_x
                max_x = bodyinfor(frame).bodies(body).joints(joint).x;
            end
            if bodyinfor(frame).bodies(body).joints(joint).y < min_y
                min_y = bodyinfor(frame).bodies(body).joints(joint).y;
            end
            if  bodyinfor(frame).bodies(body).joints(joint).y > max_y
                max_y = bodyinfor(frame).bodies(body).joints(joint).y;
            end
            if bodyinfor(frame).bodies(body).joints(joint).z < min_z
                min_z = bodyinfor(frame).bodies(body).joints(joint).z;
            end
            if  bodyinfor(frame).bodies(body).joints(joint).z > max_z
                max_z = bodyinfor(frame).bodies(body).joints(joint).z;
            end
        end
    end
end

length_x = max_x - min_x;
length_y = max_y - min_y;
length_z = max_z - min_z;
length_max = length_x;
if(length_max < length_y)
    length_max = length_y;
end
if(length_max < length_z)
    length_max = length_z;
end

colormap_jet = colormap(jet);
colormap_gray = colormap(gray);
left_body = [24, 25, 11, 12, 10, 9, 17, 18, 19, 20];
right_body = [22, 23, 7, 8, 6, 5, 13, 14, 15, 16];
center_body = [1, 2, 3, 4, 21];
for frame = 1 : length(bodyinfor)
    for body = 1 : length(bodyinfor(frame).bodies)
        for joint = 1 : 25
            if ismember(joint, left_body)
                image(1, floor((bodyinfor(frame).bodies(body).joints(joint).x - min_x) * image_size(1) / length_x) + 1, ...
                    floor((bodyinfor(frame).bodies(body).joints(joint).y - min_y) * image_size(2) / length_y) + 1, :)...
                    = colormap_jet(ceil(frame / length(bodyinfor) * length(colormap_jet)), :);
                image(2, floor((bodyinfor(frame).bodies(body).joints(joint).y - min_y) * image_size(2) / length_y) + 1, ...
                    floor((bodyinfor(frame).bodies(body).joints(joint).z - min_z) * image_size(3) / length_z) + 1, :) ...
                    = colormap_jet(ceil(frame / length(bodyinfor) * length(colormap_jet)), :);
                image(3, floor((bodyinfor(frame).bodies(body).joints(joint).z - min_z) * image_size(3) / length_z) + 1, ...
                    floor((bodyinfor(frame).bodies(body).joints(joint).x - min_x) * image_size(1) / length_x) + 1, :) ...
                    = colormap_jet(ceil(frame / length(bodyinfor) * length(colormap_jet)), :);
            else if ismember(joint, right_body)
                    image(1, floor((bodyinfor(frame).bodies(body).joints(joint).x - min_x) * image_size(1) / length_x) + 1, ...
                        floor((bodyinfor(frame).bodies(body).joints(joint).y - min_y) * image_size(2) / length_y) + 1, :)...
                        = colormap_jet(length(colormap_jet) + 1 - ceil(frame / length(bodyinfor) * length(colormap_jet)), :);
                    image(2, floor((bodyinfor(frame).bodies(body).joints(joint).y - min_y) * image_size(2) / length_y) + 1, ...
                        floor((bodyinfor(frame).bodies(body).joints(joint).z - min_z) * image_size(3) / length_z) + 1, :) ...
                        = colormap_jet(length(colormap_jet) + 1 - ceil(frame / length(bodyinfor) * length(colormap_jet)), :);
                    image(3, floor((bodyinfor(frame).bodies(body).joints(joint).z - min_z) * image_size(3) / length_z) + 1, ...
                        floor((bodyinfor(frame).bodies(body).joints(joint).x - min_x) * image_size(1) / length_x) + 1, :) ...
                        = colormap_jet(length(colormap_jet) + 1 - ceil(frame / length(bodyinfor) * length(colormap_jet)), :);
                else
                    image(1, floor((bodyinfor(frame).bodies(body).joints(joint).x - min_x) * image_size(1) / length_x) + 1, ...
                        floor((bodyinfor(frame).bodies(body).joints(joint).y - min_y) * image_size(2) / length_y) + 1, :)...
                        = colormap_gray(ceil(frame / length(bodyinfor) * length(colormap_gray)), :);
                    image(2, floor((bodyinfor(frame).bodies(body).joints(joint).y - min_y) * image_size(2) / length_y) + 1, ...
                        floor((bodyinfor(frame).bodies(body).joints(joint).z - min_z) * image_size(3) / length_z) + 1, :) ...
                        = colormap_gray(ceil(frame / length(bodyinfor) * length(colormap_gray)), :);
                    image(3, floor((bodyinfor(frame).bodies(body).joints(joint).z - min_z) * image_size(3) / length_z) + 1, ...
                        floor((bodyinfor(frame).bodies(body).joints(joint).x - min_x) * image_size(1) / length_x) + 1, :) ...
                        = colormap_gray(ceil(frame / length(bodyinfor) * length(colormap_gray)), :);
                end
            end
        end
    end
    %     colormap_jet = colormap;
    %     for i = 1 : 20
    %         for j = 1 : 64
    %             image_1(i, j, :) = colormap_jet(j,:);
    %         end
    %     end
    %     imshow(image_1)
%     
%     final_image = imrotate(reshape(image(1,:,:, :),[256, 256, 3]), 90);
%     imshow(final_image)
%     colorbar
%     
%     
    % figure
    % imshow(ones(256, 256, 3))
    % for frame = 1 : 30
    % for joint = 1 : 25
    %     text( floor((bodyinfor(frame).bodies(1).joints(joint).x - min_x) * image_size(1) / length_x) + 1, ...
    %                     floor((bodyinfor(frame).bodies(1).joints(joint).y - min_y) * image_size(2) / length_y) + 1, int2str(joint));
    % end
    % end
    
    
end
end
