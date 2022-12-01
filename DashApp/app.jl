#=
app:
- Julia version: 1.8.3
- Author: vadim
- Date: 2022-12-01
=#

using Base64

using Dash
using ImageShow, Plots, TestImages

images_names = [
    "airplaneF16",
    "autumn_leaves",
    "barbara_color",
    "barbara_gray_512",
    "bark_512",
    "bark_he_512",
    "beach_sand_512",
    "beach_sand_he_512",
    "blobs",
    "brick_wall_512",
    "brick_wall_he_512",
    "calf_leather_512",
    "calf_leather_he_512",
    "cameraman",
    "chelsea",
    "coffee",
    "earth_apollo17",
    "fabio_color_256",
    "fabio_color_512",
    "fabio_gray_256",
    "fabio_gray_512",
    "grass_512",
    "grass_he_512",
    "hela-cells",
    "herringbone_weave_512",
    "herringbone_weave_he_512",
    "house",
    "jetplane",
    "lake_color",
    "lake_gray",
    "lena_color_256",
    "lena_color_512",
    "lena_gray_16bit",
    "lena_gray_256",
    "lena_gray_512",
    "lighthouse",
    "livingroom",
    "m51",
    "mandril_color",
    "mandril_gray",
    "mandrill",
    "monarch_color",
    "monarch_color_256",
    "moonsurface",
    "morphology_test_512",
    "mountainstream",
    "mri-stack",
    "multi-channel-time-series.ome",
    "peppers_color",
    "peppers_gray",
    "pigskin_512",
    "pigskin_he_512",
    "pirate",
    "plastic_bubbles_512",
    "plastic_bubbles_he_512",
    "raffia_512",
    "raffia_he_512",
    "resolution_test_1920",
    "resolution_test_512",
    "simple_3d_ball",
    "simple_3d_psf",
    "straw_512",
    "straw_he_512",
    "sudoku",
    "toucan",
    "walkbridge",
    "water_512",
    "water_he_512",
    "woman_blonde",
    "woman_darkhair",
    "wood_grain_512",
    "wood_grain_he_512",
    "woolen_cloth_512",
    "woolen_cloth_he_512"
]

function encode(io::IOBuffer, img)
    io2=IOBuffer()
    b64pipe=Base64EncodePipe(io2)
    write(io,"data:image/png;base64,")
    show(b64pipe, MIME"image/png"(), img)
    write(io, read(seekstart(io2)))
end

function encode(file::AbstractString)
    img = testimage(file)
    io = IOBuffer()
    encode(io, img)
    String(take!(io))
end

app = dash()

app.layout = html_div() do
    html_h1("Transformations d'images"),
    dcc_dropdown(
        id = "dropdown",
        options = [(label=f, value=f) for f in images_names],
        value = "mandril",
    ),
    html_img(id="viewer", src=encode("mandril"))
end

callback!(
    app,
    Output("viewer","src"),
    Input("dropdown","value"),
) do filename
    encode(filename)
end

run_server(app, "0.0.0.0", debug=true)
