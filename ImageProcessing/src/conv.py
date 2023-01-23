import time

import numpy as np


def padding(image, filter, color):
    size_padding = int((np.shape(filter)[1] - 1) / 2)
    if color:
        image = np.pad(image, size_padding)[:, :, size_padding:(np.shape(image)[-1]+size_padding)]
    else:
        image = np.pad(image, size_padding)
    return image


def transform_pixel(i, j, padded_image, filter, color):
    size_padding = int((np.shape(filter)[0] - 1) / 2)
    i1 = i - size_padding
    i2 = i + size_padding + 1
    j1 = j - size_padding
    j2 = j + size_padding + 1
    if color:
        img_piece = np.array([])
        for col in range(np.shape(padded_image)[-1]):
            img_piece = np.append(img_piece,
                                  np.sum(padded_image[i1:i2, j1:j2, col] * filter))
        return img_piece
    else:
        return np.sum(padded_image[i1:i2, j1:j2] * filter)


def conv(image, filter):
    start_time = time.time()
    color = len(np.shape(image)) == 3
    transformed_image = image
    padded_image = padding(image, filter, color)
    dim_no_padding = np.shape(image)
    size_padding = int((np.shape(filter)[1] - 1) / 2)
    for i in range(dim_no_padding[0]):
        i_lag = i + size_padding
        for j in range(dim_no_padding[1]):
            j_lag = j + size_padding
            transformed_image[i, j] = transform_pixel(i_lag, j_lag, padded_image, filter, color)
    return transformed_image, time.time() - start_time
