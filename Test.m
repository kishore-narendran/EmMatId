image = imread('p4.png');
info = imfinfo('p4.png');
imageRep = image;
% results = ocr(i,'TextLayout','Word','Equation','C:\\Users\\kishore\\Documents\\Projects\\Embedded Math Formulae Identification\\tessdata\\equ.traineddata');
% results = ocr(i,'Language',{'tesseract-ocr/tessdata/eng.traineddata', 'tesseract-ocr/tessdata/equ.traineddata'});
results = ocr(image);
wordBoundingBoxes = results.WordBoundingBoxes;
wordConfidences = results.WordConfidences;
words = results.Words;
heights = wordBoundingBoxes(:,4);
modeHeight = mode(heights);
for i=1:(size(wordBoundingBoxes)),
    x = wordBoundingBoxes(i,1);
    y = wordBoundingBoxes(i,2);
    width = wordBoundingBoxes(i,3);
    height = wordBoundingBoxes(i,4);
    allowedHeights = modeHeight - 5: modeHeight + 5;
    matches = regexpi(words{i}, '^[A-Za-z._-: ()]{3,}$');
    isString = isstrprop(words{i}, 'alpha');
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
%     if isstrprop(words{i},'alpha') == 1,
%         image(y:y+height,x:x+width,:) = 0;
%     else if matches ~= 0,
%             image(y:y+height,x:x+width,:) = 0;
%         end
%     end
%     if matches ~= 0,
%         image(y:y+height,x:x+width,:) = 0;
%     end
end
imwrite(image, 'p5.png');
