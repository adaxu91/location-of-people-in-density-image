function group=gen_pedestrian(width,height,add_position_x,add_position_y)
    x=1:width;
    y=1:height;
    mu=[add_position_x add_position_y];
    sigma=[4 0;0 8];
    [X,Y]=meshgrid(x,y); 
    g=mvnpdf([X(:),Y(:)],mu,sigma);
    group=reshape(g,height,width);
end