%Initialize
clear;
close all;
mode = 2;
if mode==1
    load C01;
elseif mode == 2
    %Rastrigrin
    rastrigrin;
    C01 = Z;
elseif mode == 3
    %peak
    C01 = peaks;
end
hold off
mpd = 10;

%Drawing
h=surf(C01);
a=get(h,'xData');
b=get(h,'yData');
c=get(h,'zData');
hold on

BW = imregionalmax(C01);
%[x,y,z] = findpeaks3(C01,mpd);

sizeBW = size(BW);
for i = 1:sizeBW(1)
    for j = 1:sizeBW(2)
        if BW(i,j)
            scatter3(j,i,C01(i,j),'k');
        end
    end
end
    
% for i = 1:length(x)
%     scatter3(x,y,z,'k');
% end

    

