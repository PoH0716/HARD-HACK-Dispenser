import matplotlib.pyplot as plt
import matplotlib.image as mpimg
import numpy as np
import cv2
import ffmpeg
import math

def draw_lines(img, lines, color, thickness):
    line_img = np.zeros((img.shape[0], img.shape[1], 3), dtype=np.uint8)
    img = np.copy(img)
    for line in lines:
        for x1, y1, x2, y2 in line:
            cv2.line(line_img, (x1, y1), (x2, y2), color, thickness)
    img = cv2.addWeighted(img, 0.8, line_img, 1.0, 0.0)
    return img

def pipeline(image):
    height = image.shape[0]
    width = image.shape[1]

    gray_image = cv2.cvtColor(image, cv2.COLOR_RGB2GRAY)
    cannyed_image = cv2.Canny(gray_image, 100, 200)
    lines = cv2.HoughLinesP(cannyed_image, 6, np.pi/60, 300, np.array([]), 100, 30)
    if lines is None:
        return image

    left_line_x = []
    left_line_y = []
    right_line_x = []
    right_line_y = []

    for line in lines:
        for x1, y1, x2, y2 in line:
            slope = (y2 - y1) / (x2 - x1)
        if math.fabs(slope) < 0.5:
            continue
        if slope <= 0:
            left_line_x.extend([x1, x2])
            left_line_y.extend([y1, y2])
        else:
            right_line_x.extend([x1, x2])
            right_line_y.extend([y1, y2])
    min_y = int(image.shape[0] * (3 / 5))
    max_y = int(image.shape[0])
    
    if len(left_line_x) > 0 and len(right_line_x) > 0:
        poly_left = np.poly1d(np.polyfit(
            left_line_y,
            left_line_x,
            deg=1
        ))
     
        left_x_start = int(poly_left(max_y))
        left_x_end = int(poly_left(min_y))
     
        poly_right = np.poly1d(np.polyfit(
            right_line_y,
            right_line_x,
            deg=1
        ))
     
        right_x_start = int(poly_right(max_y))
        right_x_end = int(poly_right(min_y))
        line_image = draw_lines(
            image,
            [[
                [left_x_start, max_y, left_x_end, min_y],
                [right_x_start, max_y, right_x_end, min_y],
            ]],
            [255, 0, 0],
            5,
        )
        return line_image
    else:
        return image

cap = cv2.VideoCapture(0)

while True:
    _, frame = cap.read()
    line_detect = pipeline(frame)

    cv2.imshow('line_detect', line_detect)

    k = cv2.waitKey(5) & 0xFF
    if k == 27:
        break

cv2.destroyAllWindows()
cap.release()
