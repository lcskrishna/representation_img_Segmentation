clear all;
close all;
clc;

prefix = {'key'};

for count = 1: 4
    
    
    fn = sprintf('%s.%d.jpg',prefix{1},count);
    img = imread(fn);
    
    gray_im = rgb2gray(img);
    
    bw= im2bw(gray_im);
    bw = ~bw;
    
    %% Closing.
    se = strel('square',5);
    closed_im = imclose(bw,se);
    
    %% Find the largest Region.
    L= bwlabel(closed_im);
    
        
    [stats] = regionprops(L,'Area');
    disp(stats);
    x= [stats.Area];
    disp(max(x));
    
    max_image = zeros(size(closed_im));
    [~,index] = max(x);
    max_image((L==index))=1;
%     titleStr = sprintf('Binary Image after closing for Key Image %d',count);
%     figure,imshow(max_image,[]);title(titleStr);
    
    
    [centroid_stats] = regionprops(max_image,'Centroid');
    disp('Centroid');
    disp([centroid_stats.Centroid]);
    
    [centroidValues] = floor(centroid_stats.Centroid);
    
    [majorAxis_stats] = regionprops(max_image,'MajorAxisLength');
    majorAxis = majorAxis_stats.MajorAxisLength;
    
    [minorAxis_stats]= regionprops(max_image,'MinorAxisLength');
    minorAxis = minorAxis_stats.MinorAxisLength;
    
    D = sqrt( (majorAxis/2)^2 + (minorAxis/2)^2);
    disp('Maximum Distance');
    disp(D);
    D= floor(D);
    r= [];
    for theta = 0:359
        
        for d = 1:50:D
            newR = floor(centroidValues(2) + d * sind(theta));
            newC = floor(centroidValues(1) + d * cosd(theta));
            
            if(max_image(newR,newC)== false)
                r(359-theta+1) = d;
                break;
            end
            
        end
        
    end
%     titleStr = sprintf('Centroid Distance function for the image %d',count);
%     figure, plot(r); title(titleStr);
    
    % r = r/D;
    maximum_value = max(max(r(:)));
    disp('Max of R');
    disp(maximum_value);
    
    thetaMax = find(maximum_value == r)
    thetaMax = thetaMax(1);
    thetaNew = [0:359];
    rNewValue = [];
    for thetaNew = 1:360
        i = thetaMax + thetaNew;
%         disp(i);
        if(i > 360)
            i = abs(i - 360);
        end
        rNewValue(thetaNew) = r(i);
    end
    
    
    
    r = r/maximum_value;
    rNewValue = rNewValue / max(rNewValue(:));
    hold on;
    plot([0:359],r,'-r'); title('Scale Normalization vs Scale and Rotation Normalization');
    hold off;
    hold on ;
    plot([0:359],rNewValue,'-b');
    hold off;
 

end


