function [A cgt n density_all] = gen_cgt(pedestrain_nmb,width,height,wnd_nmb,wnd_size)
    density_all=zeros(height,width); %density image
    n=zeros(wnd_nmb,1); %ni=di'*wi 
    cgt=zeros(height,width); %matrix wanted to be recovered
    window=zeros(height,width); %wi
    w=zeros(height*width,1); %for vectorization
    A=zeros(wnd_nmb,width*height); 
    row=1;
    
    for i=1:pedestrain_nmb %build up the matrix of density image with Gaussian Distribution           
        rng('shuffle');
        add_position_x=randi([1,width-1]);
        add_position_y=randi([1,height-1]);
        cgt(add_position_y,add_position_x)=cgt(add_position_y,add_position_x)+1; %build up the matrix of counted ground truth
        group=gen_pedestrian(width,height,add_position_x,add_position_y);
        density_all=density_all+group;
        
        %for experiment
%         add_position_x=1;
%         add_position_y=1;
%         cgt(add_position_y,add_position_x)=cgt(add_position_y,add_position_x)+1; %build up the matrix of counted ground truth
%         group=gen_pedestrian(width,height,add_position_x,add_position_y);
%         density_all=density_all+group;
%         
%         add_position_x=15;
%         add_position_y=15;
%         cgt(add_position_y,add_position_x)=cgt(add_position_y,add_position_x)+1; %build up the matrix of counted ground truth
%         group=gen_pedestrian(width,height,add_position_x,add_position_y);
%         density_all=density_all+group;
%         
%         add_position_x=16;
%         add_position_y=16;
%         cgt(add_position_y,add_position_x)=cgt(add_position_y,add_position_x)+1; %build up the matrix of counted ground truth
%         group=gen_pedestrian(width,height,add_position_x,add_position_y);
%         density_all=density_all+group;
%         
%         add_position_x=20;
%         add_position_y=20;
%         cgt(add_position_y,add_position_x)=cgt(add_position_y,add_position_x)+1; %build up the matrix of counted ground truth
%         group=gen_pedestrian(width,height,add_position_x,add_position_y);
%         density_all=density_all+group;
%         
%         add_position_x=1;
%         add_position_y=38;
%         cgt(add_position_y,add_position_x)=cgt(add_position_y,add_position_x)+1; %build up the matrix of counted ground truth
%         group=gen_pedestrian(width,height,add_position_x,add_position_y);
%         density_all=density_all+group;
%         
%         add_position_x=2;
%         add_position_y=63;
%         cgt(add_position_y,add_position_x)=cgt(add_position_y,add_position_x)+1; %build up the matrix of counted ground truth
%         group=gen_pedestrian(width,height,add_position_x,add_position_y);
%         density_all=density_all+group;
%         
%         add_position_x=48;
%         add_position_y=32;
%         cgt(add_position_y,add_position_x)=cgt(add_position_y,add_position_x)+1; %build up the matrix of counted ground truth
%         group=gen_pedestrian(width,height,add_position_x,add_position_y);
%         density_all=density_all+group;
%         
%         add_position_x=58;
%         add_position_y=15;
%         cgt(add_position_y,add_position_x)=cgt(add_position_y,add_position_x)+1; %build up the matrix of counted ground truth
%         group=gen_pedestrian(width,height,add_position_x,add_position_y);
%         density_all=density_all+group;
%         
%         add_position_x=33;
%         add_position_y=60;
%         cgt(add_position_y,add_position_x)=cgt(add_position_y,add_position_x)+1; %build up the matrix of counted ground truth
%         group=gen_pedestrian(width,height,add_position_x,add_position_y);
%         density_all=density_all+group;
%         
%         add_position_x=50;
%         add_position_y=2;
%         cgt(add_position_y,add_position_x)=cgt(add_position_y,add_position_x)+1; %build up the matrix of counted ground truth
%         group=gen_pedestrian(width,height,add_position_x,add_position_y);
%         density_all=density_all+group;
    end
    figure(1);
    imagesc(density_all);
    
    for i=1:4:height-wnd_size(1,2)+1 %row
        for j=1:4:width-wnd_size(1,1)+1 %column
            window(i:i+wnd_size(1,2)-1,j:j+wnd_size(1,1)-1)=1;     
            n_cashe=density_all(i:i+wnd_size(1,2)-1,j:j+wnd_size(1,1)-1);
            n_i=sum(n_cashe(:));
            n(row,1)=n_i;   
            w=reshape(window,width*height,1); %vectorize the window matrix
            A(row,:)=w';
            row=row+1;
            window(i:i+wnd_size(1,2)-1,j:j+wnd_size(1,1)-1)=0;
        end
    end
end