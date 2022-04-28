import cv2
import numpy as np
from matplotlib import pyplot
img = cv2.imread('./win-screen.png')
f= open("win.txt","w+")
x = 90
y = 92
print ('RGB shape: ', img.shape)
print (img[x, y])
# print((img[x, y][0] and img[x,y][1] and img[x,y][2]) == 0)




for i in range(0,256):
	for j in range(0,256):
		q = img[j,i]
		if ((q[0] and q[1] and q[2]) != 0):
			# print("{} comma {}".format(i, j))
			# print(img[j,i])
			offset = (i*4)+(j*1024)
			string = "sw $s2, {}($s0)\n".format(offset)
			f.write(string)

f.close()
			


# pyplot.imshow(img)
# pyplot.show()

