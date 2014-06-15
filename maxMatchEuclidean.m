function error=maxMatchEuclidean(recovery,cgt_all,width,height,pedestrain_nmb)
error=0;
pos_true=zeros(pedestrain_nmb,2);
pos_recover=zeros(pedestrain_nmb,2);
nmb_true=0;
nmb_recover=0;

for i=1:height    %get the points' positions
   for j=1:width
       if cgt_all(i,j)==1
           nmb_true=nmb_true+1;
           pos_true(nmb_true,1)=i;
           pos_true(nmb_true,2)=j;
       end
       if recovery(i,j)> 0.999
           nmb_recover=nmb_recover+1;
           pos_recover(nmb_recover,1)=i;
           pos_recover(nmb_recover,2)=j;
       end
   end
end
nmb_true
nmb_recover
missing_nmb=(nmb_true-nmb_recover)
% extra_nmb=nmb_recover-nmb_true

% if missing_nmb~=0
%     miss_flag=1; 
% end

distance=zeros(nmb_true,nmb_recover);
distance_tmp=zeros(nmb_true,nmb_recover);

for i=1:nmb_true   %get the distances' matrix 
   for j=1:nmb_recover  
       dis=(sqrt((pos_true(i,1)-pos_recover(j,1))^2+(pos_true(i,2)-pos_recover(j,2))^2));
       distance(i,j)=dis;
       distance_tmp(i,j)=dis;
   end
end

pos_y=zeros(nmb_true,2); %record the position of each smallest element
for i=1:nmb_true    
    min=distance_tmp(i,1);
    pos_y(i,1)=1;
    pos_y(i,2)=0; %it presents the pos has not been counted yet
   for j=2:nmb_recover   %find the smallest element in each row
       if min>distance_tmp(i,j)
          min=distance_tmp(i,j);
          pos_y(i,1)=j;
       end
   end
   for j=1:nmb_recover   %substract the smallest element from each element
       distance_tmp(i,j)=distance_tmp(i,j)-min;
   end   
end

count=0;
while (1)
   for i=1:nmb_true-1  %get the smallest error
        row=i;
        min=distance(i,pos_y(i,1));
        for j=i:nmb_true  %find if the distances can be assigned properly  
           if pos_y(i,2)==0  
              if pos_y(i,1)==pos_y(j,1)
                   if min>distance(j,pos_y(j,1)) 
                       min=distance(j,pos_y(j,1));
                       row=j;
                   end
                   pos_y(j,2)=2; %has the same colomn number
              end 
           end
        end
        error=error+distance(row,pos_y(row,1));
        pos_y(row,2)=1; %it has been counted
        count=count+1;
   end 
   
   if pos_y(nmb_true,2)==0
       error=error+distance(nmb_true,pos_y(nmb_true,1));
       pos_y(nmb_true,2)=1;
       count=count+1;
   end
   
   if count<nmb_recover && count<nmb_true
      for i=1:nmb_true %get the smaller elements
       if pos_y(i,2)~=1
          start=1;
          while(distance_tmp(i,start)<=0)
              start=start+1;
          end
          min=distance_tmp(i,start);
          pos_y(i,1)=start;
          pos_y(i,2)=0;
          for j=start+1:nmb_recover
              if distance_tmp(i,j)>0
                  if min>distance_tmp(i,j)
                      min=distance_tmp(i,j);
                      pos_y(i,1)=j;
                  end 
              end
          end
          for j=1:nmb_recover   %substract the smallest element from each element
              distance_tmp(i,j)=distance_tmp(i,j)-min;
          end
       end
      end 
   else
       break;
   end
end
end