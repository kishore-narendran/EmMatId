from PIL import Image
import PIL
import csv
im = Image.open('line left43.png')
image = im.load()
width,height=im.size

newIm = Image.new("RGB", im.size)

count = 0
output=[]

putpixel = newIm.im.putpixel
threshold = 150

for y in range(height):
	temp=[]
	for x in range(width):
		r,g,b=image[x,y]
		if r<threshold and g<threshold and b<threshold:
			count=count+1
			putpixel((x,y),(0,0,0))
			temp.append(1)
		else:
			temp.append(0)
			putpixel((x,y),(255,255,255))
	output.append(temp)
	

print "-"*35
print "Writing to file: maskdump.csv"
print "-"*35

myfile=open('maskdump.csv','wb')
wr=csv.writer(myfile, quoting=csv.QUOTE_ALL)

for line in output:
	wr.writerow(line)

print "Saving image"
print "-"*35
newIm.save("pixeldump.png")

print "Accepted pixels:",count
print "Total Pixel:",width,"*",height,"=",width*height
print "-"*35