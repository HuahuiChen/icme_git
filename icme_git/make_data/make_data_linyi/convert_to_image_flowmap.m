function [out_put]= convert_to_image_flowmap(filename)

% convert_to_image('./nturgb+d_skeletons/S002C003P014R002A007.skeleton')
bodyinfo=read_skeleton_file(filename);
fileid = fopen(filename);
% framecount = fscanf(fileid,'%d',1)
framecount=numel(bodyinfo);
flag1_count=0;
flag2_count=0;
flag3_count=0;
R1= zeros(25,framecount);
B1= zeros(25,framecount);
G1= zeros(25,framecount);
R2= zeros(25,framecount);
G2= zeros(25,framecount);
B2= zeros(25,framecount);
R3= zeros(25,framecount);
G3= zeros(25,framecount);
B3= zeros(25,framecount);
part_vector= [24,25,12,11,10,9,22,23,8,7,6,5,1,2,21,3,4,20,19,18,17,16,15,14,13];

bodyID_matrix =[];
body_num_tmp = 0;
i=1;
for f = 1:framecount
    for b = 1:numel(bodyinfo(f).bodies)
        if b > body_num_tmp
            body_num_tmp = b;
        end        
        bodyID = rem(bodyinfo(f).bodies(b).bodyID,1000);%bodyID只取后三位
        if ~ismember(bodyID, bodyID_matrix)
            bodyID_matrix(i) = bodyID;
            i = i+1;
        end        
    end
end

for f=1:framecount
    bodycount=numel(bodyinfo(f).bodies);   
if bodycount==1
   flag1_count=1;
   b=bodyinfo(f).bodies(1).joints; 
   bodyid=rem(bodyinfo(f).bodies(1).bodyID,1000);
   [n,id]=find(bodyID_matrix==bodyid);
   switch id
       case 1
           for j = 1:size(part_vector,2)
               R1(j,f)=b(part_vector(j)).x;
               G1(j,f)=b(part_vector(j)).y;
               B1(j,f)=b(part_vector(j)).z;
           end
       case 2
           for j = 1:size(part_vector,2)
               R2(j,f)=b(part_vector(j)).x;
               G2(j,f)=b(part_vector(j)).y;
               B2(j,f)=b(part_vector(j)).z;
           end
       case 3
           for j = 1:size(part_vector,2)
               R3(j,f)=b(part_vector(j)).x;
               G3(j,f)=b(part_vector(j)).y;
               B3(j,f)=b(part_vector(j)).z;
           end    
   end      
else if bodycount==2
        flag2_count=2;
        for i=1:2
            b=bodyinfo(f).bodies(i).joints; 
            bodyid=rem(bodyinfo(f).bodies(i).bodyID,1000);
            [n,id]=find(bodyID_matrix==bodyid);
            switch id
                   case 1
                        for j = 1:size(part_vector,2)
                            R1(j,f)=b(part_vector(j)).x;
                            G1(j,f)=b(part_vector(j)).y;
                            B1(j,f)=b(part_vector(j)).z;
                        end
                    case 2
                        for j = 1:size(part_vector,2)
                            R2(j,f)=b(part_vector(j)).x;
                            G2(j,f)=b(part_vector(j)).y;
                            B2(j,f)=b(part_vector(j)).z;
                            end
                    case 3
                        for j = 1:size(part_vector,2)
                            R3(j,f)=b(part_vector(j)).x;
                            G3(j,f)=b(part_vector(j)).y;
                            B3(j,f)=b(part_vector(j)).z;
                        end    
            end  
        end
    else if bodycount==3 
            b=bodyinfo(f).bodies(1).joints; 
            flag3_count=3;
            for i=1:3
                b=bodyinfo(f).bodies(i).joints; 
                bodyid=rem(bodyinfo(f).bodies(i).bodyID,1000);
                [n,id]=find(bodyID_matrix==bodyid);
                switch id
                        case 1
                             for j = 1:size(part_vector,2)
                                 R1(j,f)=b(part_vector(j)).x;
                                 G1(j,f)=b(part_vector(j)).y;
                                 B1(j,f)=b(part_vector(j)).z;
                             end
                        case 2
                            for j = 1:size(part_vector,2)
                                R2(j,f)=b(part_vector(j)).x;
                                G2(j,f)=b(part_vector(j)).y;
                                B2(j,f)=b(part_vector(j)).z;
                            end
                        case 3
                            for j = 1:size(part_vector,2)
                                R3(j,f)=b(part_vector(j)).x;
                                G3(j,f)=b(part_vector(j)).y;
                                B3(j,f)=b(part_vector(j)).z;
                            end    
                end  
            end                    
        else
        end
end
end
end
flag_count=[flag1_count,flag2_count,flag3_count];
person_count=max(flag_count);

if person_count==3
   R = [R1;R2;R3]; 
   B = [B1;B2;B3];
   G = [G1;G2;G3];
else if person_count==2
        R = [R1;R2];
        B = [B1;B2];
        G = [G1;G2];
    else
        R = [R1];
        B = [B1];
        G = [G1];
    end
end

R_N=[];
G_N=[];
B_N=[];
A = R(:,2:end);
C = R(:,1:end-1);
R_N = A-C;

index_R = R == 0;
index_A = index_R(:,2:end);
index_B = index_R(:,1:end-1);
index = logical(index_A-index_B);
index = sum(index, 1);
[a,b] = find(index==0);
b = unique(b);
R_N = R_N(:,b);

A = G(:,2:end);
C = G(:,1:end-1);
G_N = A-C;
G_N =G_N(:,b);

A = B(:,2:end);
C = B(:,1:end-1);
B_N = A-C;
B_N = B_N(:,b);

r_max=max(max(R_N));
g_max=max(max(G_N));
b_max=max(max(B_N));
r_min=min(min(R_N));
g_min=min(min(G_N));
b_min=min(min(B_N));
index_0 = R_N ==0;

R_N = floor(255*((R_N-r_min)/(r_max-r_min)));
G_N = floor(255*((G_N-g_min)/(g_max-g_min)));
B_N = floor(255*((B_N-b_min)/(b_max-b_min)));

R_N=uint8(R_N);
G_N=uint8(G_N);
B_N=uint8(B_N);

R_N(index_0) = 255;
G_N(index_0) = 255;
B_N(index_0) = 255;


out_put(:,:,1)=R_N;   
out_put(:,:,2)=G_N;  
out_put(:,:,3)=B_N;

out_put=imresize(out_put,[227,227]);
fclose(fileid);
end

