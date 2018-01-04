function [out_put] = create_map( filename, resize_height, resize_width )
data=load(filename);
[row,column]=size(data);
R1= zeros(row,25);
B1= zeros(row,25);
G1= zeros(row,25);
R2= zeros(row,25);
G2= zeros(row,25);
B2= zeros(row,25);
n1=1;
n2=1;

for i=1:3:73
     R1(:,n1)=data(:,i);
     G1(:,n1)=data(:,(i+1));
     B1(:,n1)=data(:,(i+2)); 
     n1=n1+1; 
end

for p=76:3:148
    R2(:,n2)=data(:,p);
    G2(:,n2)=data(:,(p+1));
    B2(:,n2)=data(:,(p+2));   
    n2=n2+1;
end        

R= [R1,R2];
G= [G1,G2];
B= [B1,B2];

r_max=max(max(R));
g_max=max(max(G));
b_max=max(max(B));
r_min=min(min(R));
g_min=min(min(G));
b_min=min(min(B));
index_0 = R ==0;

R_N = floor(255*((R-r_min)/(r_max-r_min)));
G_N = floor(255*((G-g_min)/(g_max-g_min)));
B_N = floor(255*((B-b_min)/(b_max-b_min)));

R_N=uint8(R_N);
G_N=uint8(G_N);
B_N=uint8(B_N);

R_N(index_0) = 255;
G_N(index_0) = 255;
B_N(index_0) = 255;
R_N = permute(R_N,[2,1]);
G_N = permute(G_N,[2,1]);  %matrix transpose 
B_N = permute(B_N,[2,1]);
out_put(:,:,1)=R_N;   
out_put(:,:,2)=G_N;  
out_put(:,:,3)=B_N;
out_put=imresize(out_put,[resize_height,resize_width]); 

end

