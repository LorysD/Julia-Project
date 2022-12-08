function conv(img::Matrix{RGB{N0f8}}, filter::Matrix{Int8})
    img_size = size(img)
    filter_size = size(filter)
    filter_weight = sum(filter)
    filter = filter ./ sum(filter)
    padding = convert(Tuple{Integer, Integer}, floor.(filter_size ./ 2))

    img_pad_size = img_size .+ padding .* 2
    img_pad, _ = sym_paddedviews(0, img, zeros(RGB{N0f8}, img_pad_size))
    img_out = zeros(RGB{N0f8}, img_size)
    for i in 1:img_size[1]
        for j in 1:img_size[2]
            pixel = sum(img_pad[i-padding[1]:i+padding[1],
                j-padding[2]:j+padding[2]] .* filter)
            img_out[i, j] = clamp01(pixel)
        end
    end
    img_out
end

export conv
