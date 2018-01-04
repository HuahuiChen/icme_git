% Project skeleton to different planes. This code contains body encode and
% direction encode, and saturation, brightness
% size of image is [view_num, 256, 256, 3].
% Edited by Huahui Chen, 2017.3.13

function image = proj_skeleton(bodyinfor)
image_size = [255 255 255];

% white background in hsv color space
image = zeros(3, 256, 256, 3);
image(:, :, :, 3) = 1;




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


colormap_jet = colormap(jet);
colormap_jet = rgb2hsv(colormap_jet);
colormap_jet(:, 2:3) = 0;
colormap_gray = colormap(gray);
colormap_gray = rgb2hsv(colormap_gray);
colormap_gray(:, 2:3) = 0;


left_body = [24, 25, 11, 12, 10, 9, 17, 18, 19, 20];
right_body = [22, 23, 7, 8, 6, 5, 13, 14, 15, 16];
center_body = [1, 2, 3, 4, 21];
for frame = 1 : length(bodyinfor)
    for body = 1 : length(bodyinfor(frame).bodies)
        for joint = 1 : 25
            % encode direction and body parts
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
end




% max speed
max_speed = 0;
for frame = 2 : length(bodyinfor)
    for body = 1 : length(bodyinfor(frame).bodies)
        for joint = 1 : 25
%             [frame body joint]
            %    S001C001P001R002A059.skeleton    'S017C003P020R001A059.skeleton';
            if (length(bodyinfor(frame).bodies) - length(bodyinfor(frame - 1).bodies) ~= 0) 
                cur_speed = 0;
            else
                cur_speed = sqrt(...
                    (bodyinfor(frame).bodies(body).joints(joint).x - bodyinfor(frame - 1).bodies(body).joints(joint).x) ^2 + ...
                    (bodyinfor(frame).bodies(body).joints(joint).y - bodyinfor(frame - 1).bodies(body).joints(joint).y) ^2 + ...
                    (bodyinfor(frame).bodies(body).joints(joint).z - bodyinfor(frame - 1).bodies(body).joints(joint).z) ^2);
                if cur_speed > max_speed
                    max_speed = cur_speed;
                end
            end
        end
    end
end


for frame = 2 : length(bodyinfor)
    for body = 1 : length(bodyinfor(frame).bodies)
        for joint = 1 : 25
            % encode saturation and brightness
            if (length(bodyinfor(frame).bodies) - length(bodyinfor(frame - 1).bodies) ~= 0)
                cur_speed = 0;
            else
                cur_speed = sqrt(...
                    (bodyinfor(frame).bodies(body).joints(joint).x - bodyinfor(frame - 1).bodies(body).joints(joint).x) ^2 + ...
                    (bodyinfor(frame).bodies(body).joints(joint).y - bodyinfor(frame - 1).bodies(body).joints(joint).y) ^2 + ...
                    (bodyinfor(frame).bodies(body).joints(joint).z - bodyinfor(frame - 1).bodies(body).joints(joint).z) ^2);
                image(1, floor((bodyinfor(frame).bodies(body).joints(joint).x - min_x) * image_size(1) / length_x) + 1, ...
                    floor((bodyinfor(frame).bodies(body).joints(joint).y - min_y) * image_size(2) / length_y) + 1, 2:3)...
                    = [cur_speed / max_speed, cur_speed / max_speed];
                image(2, floor((bodyinfor(frame).bodies(body).joints(joint).y - min_y) * image_size(2) / length_y) + 1, ...
                    floor((bodyinfor(frame).bodies(body).joints(joint).z - min_z) * image_size(3) / length_z) + 1, 2:3) ...
                    = [cur_speed / max_speed, cur_speed / max_speed];
                image(3, floor((bodyinfor(frame).bodies(body).joints(joint).z - min_z) * image_size(3) / length_z) + 1, ...
                    floor((bodyinfor(frame).bodies(body).joints(joint).x - min_x) * image_size(1) / length_x) + 1, 2:3) ...
                    = [cur_speed / max_speed, cur_speed / max_speed];
            end
        end
    end
end



end
