image = imread('p3.png');
results = ocr(image,'Language',{'tesseract-ocr/tessdata/equ.traineddata'});
