function [x,loca,pks] = findpeaks3(Matrix3,minpeakdistance) %#ok<*STOUT>
    Maxv1 = [];Maxl1 = [];Maxv2 = [];Maxl2 = [];MaxNum = [];
    for i = 1:length(Matrix3)
        [maxv1,maxl1] = findpeaks(Matrix3(i,:),'minpeakdistance',minpeakdistance);
        [maxv2,maxl2] = findpeaks(Matrix3(:,i),'minpeakdistance',minpeakdistance);
        size1 = size(maxv1);
        size2 = size(maxv2);
        if(size1(1)>1)
            maxv1 = maxv1';
            maxl1 = maxl1';
        end
        if(size2(1)>1)
            maxv2 = maxv2';
            maxl2 = maxl2';
        end
        Maxv1 = [Maxv1,maxv1];
        Maxl1 = [Maxl1,maxl1];
        Maxv2 = [Maxv2,maxv2];
        Maxl2 = [Maxl2,maxl2];
        MaxNum = [MaxNum,length(maxv1)];
    end
    
%error by intersect. solution: change to 3d array 
[pks,j] = intersect(Maxv1,Maxv2,'stable');

x = Maxl1(j);
loca = ones(1,length(j));
for i = 1:length(j)
    k=2;sum = MaxNum(1);
    while j(i)-sum>0
        sum = sum+MaxNum(k);
        loca(i) = loca(i)+1;
        k=k+1;
    end
end

