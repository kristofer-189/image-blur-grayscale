import imageio as iio
from matplotlib import pyplot as plt
from PIL import Image
import numpy as np
import sys

def blur_image(image):
    newimage = np.zeros(image.shape, dtype=np.uint8)
    offset = [-1, 0, 1]
    offset = np.arange(-1, 1 + 1, 1, dtype=int)
    height = image.shape[0]
    width = image.shape[1]
    for y in range(height):
        for x in range(width):
            r_total = g_total = b_total = count = 0
            for dy in offset:
                ny = y + dy
                if ny < 0 or ny >= height:
                    continue
                for dx in offset:
                    nx = x + dx
                    if nx < 0 or nx >= width:
                        continue
                    r_total += image[ny][nx][0]
                    g_total += image[ny][nx][1]
                    b_total += image[ny][nx][2]
                    count += 1
            newimage[y][x][0] = r_total // count
            newimage[y][x][1] = g_total // count
            newimage[y][x][2] = b_total // count
    return newimage

def grayscale_image(image):
    height = image.shape[0]
    width = image.shape[1]
    newimage = np.zeros((height, width), dtype=np.uint8)
    for y in range(height):
        for x in range(width):
            r = float(image[y][x][0]) / 255.0
            g = float(image[y][x][1]) / 255.0
            b = float(image[y][x][2]) / 255.0
            c = 0.2126 * r + 0.7152 * g + 0.0722 * b
            newimage[y][x] = c * 255
    return newimage

if __name__ == "__main__":
    img = str(sys.argv[1])
    mode = int(sys.argv[2])
    # print(img)
    # print(mode)
    img = iio.imread(img)
    if(mode == 1):
        print("Blur")
        imgblur = blur_image(img)
        print("Blur done")
        img = Image.fromarray(imgblur, 'RGB')
    elif(mode == 2):
        print("Gray")
        imggray = grayscale_image(img)
        print("Gray done")
        img = Image.fromarray(imggray, 'L')
    else:
        exit(1)
    print("Done")
    img.save('output.png')
    exit(0)