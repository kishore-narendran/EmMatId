image = imread('p2.png');
info = imfinfo('p2.png');
imageRep = image;
% results = ocr(i,'TextLayout','Word','Equation','C:\\Users\\kishore\\Documents\\Projects\\Embedded Math Formulae Identification\\tessdata\\equ.traineddata');
% results = ocr(i,'Language',{'tesseract-ocr/tessdata/eng.traineddata', 'tesseract-ocr/tessdata/equ.traineddata'});
results = ocr(image);
wordBoundingBoxes = results.WordBoundingBoxes;
wordConfidences = results.WordConfidences;
words = results.Words;
heights = wordBoundingBoxes(:,4);
modeHeight = mode(heights);
w = info.Width;
h = info.Height;
maxwhite = 0;
maxx = 1;

%Finding the segmentation to divide the page into two
for x = round(0.25*w):round(0.75*w),
    count = 0;
    for y = 1:h,
        rgb = image(y,x,:);
        if (rgb(1) == 255 && rgb(2) == 255 && rgb(3) == 255),
            count = count + 1;
        end 
    end
    if count > maxwhite;
        maxwhite = count;
        maxx = x;
    end
end

image1 = image(:,1:maxx,:);
image2 = image(:,maxx:w,:);
imwrite(image1,'p4.png');
imwrite(image2,'p5.png');

%Finding the segments in the left side of the image

imagel = imread('p4.png');
infol = imfinfo('p4.png');
wl = infol.Width;
hl = infol.Height;
whitelinesl = [];

for i=1:hl,
    count = 0;
    for j=1:wl,
        rgb = imagel(i,j,:);
        if (rgb(1) == 0 && rgb(2) == 0 && rgb(3) == 0),
            count = count + 1;
        end 
    end
    if(count == 0),
        whitelinesl(end + 1) = i;
    end
end

refinedwhitelinesl = [];
refinedwhitelinesl(end + 1) = whitelinesl(1);
indexl = 1;
lenwhitelinesl = size(whitelinesl);
lenwhitelinesl = lenwhitelinesl(2);

for i=2:lenwhitelinesl,
    if((whitelinesl(i) - 1) == whitelinesl(i - 1)),
        continue;
    else
        refinedwhitelinesl(end + 1) = whitelinesl(i);
    end
end

%Finding the segments in the right side of the image

imager = imread('p5.png');
infor = imfinfo('p5.png');
wr = infor.Width;
hr = infor.Height;
whitelinesr = [];

for i=1:hr,
    count = 0;
    for j=1:wr,
        rgb = imager(i,j,:);
        if (rgb(1) == 0 && rgb(2) == 0 && rgb(3) == 0),
            count = count + 1;
        end 
    end
    if(count == 0),
        whitelinesr(end + 1) = i;
    end
end

refinedwhitelinesr = [];
refinedwhitelinesr(end + 1) = whitelinesr(1);
lenwhitelinesr = size(whitelinesr);
lenwhitelinesr = lenwhitelinesr(2);

for i=2:lenwhitelinesr,
    if((whitelinesr(i) - 1) == whitelinesr(i - 1)),
        continue;
    else
        refinedwhitelinesr(end + 1) = whitelinesr(i);
    end
end

imagel = image(:,1:maxx,:);
imager = image(:,maxx:w,:);
imwrite(imagel,'p4.png');
imwrite(imager,'p5.png');

for i=1:(size(wordBoundingBoxes)),
    x = wordBoundingBoxes(i,1);
    y = wordBoundingBoxes(i,2);
    width = wordBoundingBoxes(i,3);
    height = wordBoundingBoxes(i,4);
    allowedHeights = modeHeight - 5: modeHeight + 5;
    matches = regexpi(words{i}, '^[A-Za-z._-: ()]{3,}$');
    yearMatches = regexp(words{i}, '[1,2]{1}[0-9]{1}[0-9]{1}[0-9]{1}');
    isString = isstrprop(words{i}, 'alpha');
    isStringLen4 = regexp(words{i}, '[A-Za-z]{4,}');
    wordCount = 0;
    flag = 1;
    if x < (info.Width/2),
        flag = 0;
    end
    for j=1:(size(wordBoundingBoxes)),
        if flag == 0 && (wordBoundingBoxes(j,1) < (info.Width/2)) && wordBoundingBoxes(j,2) == y && i ~= j,
            wordCount = wordCount + 1;
        else if flag == 1 && (wordBoundingBoxes(j,1) > (info.Width/2)) && wordBoundingBoxes(j,2) == y && i ~= j,
                wordCount = wordCount + 1;
            end
        end
    end
    if (wordCount > 3) && (wordConfidences(i) > 0.76),
        image(y:y+height,x:x+width,:) = 255;
    end
    if (matches ~= 0),
        if wordConfidences(i) > 0.76,
            image(y:y+height,x:x+width,:) = 255;
        end
    end
    if (yearMatches ~= 0),
        image(y:y+height,x:x+width,:) = 255;
    end
    if(isString),
        if(wordCount > 4),
            image(y:y+height,x:x+width,:) = 255;
        end
    end
    if(isStringLen4),
        if(wordCount > 4),
            image(y:y+height,x:x+width,:) = 255;
        end
    end
end
imwrite(image, 'p3.png');

imagel = image(:,1:maxx,:);
imager = image(:,maxx:w,:);
imwrite(imagel,'p6.png');
imwrite(imager,'p7.png');

%imagel = imread('p4.png');
%imager = imread('p5.png');

lenwhitelinesl = size(refinedwhitelinesl);
lenwhitelinesl = lenwhitelinesl(2);

lenwhitelinesr = size(refinedwhitelinesr);
lenwhitelinesr = lenwhitelinesr(2);

for i=1:lenwhitelinesl-1,
    imagetemp = imagel(refinedwhitelinesl(i):refinedwhitelinesl(i+1),:,:);
    imwrite(imagetemp, strcat('line left',num2str(i),'.png'));
end

for i=1:lenwhitelinesr-1,
    imagetemp = imager(refinedwhitelinesr(i):refinedwhitelinesr(i+1),:,:);
    imwrite(imagetemp, strcat('line right',num2str(i),'.png'));
end