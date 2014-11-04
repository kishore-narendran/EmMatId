from PIL import Image
import PIL
im = Image.open('p4.png')
image = im.load()
width, height = im.size
whiteline = []
refinedwhiteline = []
flags = []
flags.append(False)
for i in range(0, height, 1):
	flag = True
	for j in range(0, width, 1):
		r, g, b = im.getpixel((j,i))
		if(r == 0 or g == 0 or b == 0):
			flag = False
	if flag:
		whiteline.append(i)

for i in range(1, len(whiteline)-1, 1):
	if(whiteline [i-1] + 1 == whiteline[i] and whiteline [i+1] - 1 == whiteline[i]):
		flags.append(False)
	else:
		flags.append(True)

flags.append(False)

for i in range(0, len(whiteline), 1):
	if flags[i]:
		refinedwhiteline.append(whiteline[i])

for i in refinedwhiteline:
	for j in range(0, width, 1):
		im.putpixel((j, i), (0,0,0))

im.save("testp.png")