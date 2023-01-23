#=
app:
- Julia version: 1.8.3
- Author: vadim
- Date: 2022-12-01
=#

using Base64

using Dash
using FileIO, Images, ImageShow, Plots, TestImages

include("../ImageProcessing/src/ImageProcessing.jl")

const images_names = [
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
    "lighthouse",
    "livingroom",
    "m51",
    "mandril_color",
    "mandril_gray",
    "monarch_color",
    "monarch_color_256",
    "moonsurface",
    "morphology_test_512",
    "mountainstream",
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
const default_image_name = "fabio_color_512"
const current_image = testimage(default_image_name)

const filters_names = [
    "identité",
    "flou",
    "net",
    "gaufrage",
    "fabio",
    "julia",
    "Python",
    "R"
]
const default_filter = "identité"

function encode(io::IOBuffer, img::Matrix)
    io2 = IOBuffer()
    b64pipe = Base64EncodePipe(io2)
    write(io,"data:image/png;base64,")
    show(b64pipe, MIME"image/png"(), img)
    write(io, read(seekstart(io2)))
end

# calls from the client when the value of the image selection dropdown changes
function encode(img::Matrix)
    io = IOBuffer()
    encode(io, img)
    String(take!(io))
end

const app = dash()

app.layout = html_div(id="main") do
    html_h1("Transformations d'images"),
    html_div(
        id = "image-div",
        [
            html_div(
                id = "input-div",
                [
                    dcc_dropdown(
                        id = "input-dropdown",
                        options = [(label = f, value = f) for f in images_names],
                        value = default_image_name,
                        clearable = false
                    ),
                    html_div(
                        id = "input-viewer-wrapper",
                        className = "viewer-wrapper",
                        [
                            html_img(
                                id = "input-viewer",
                                className = "viewer",
                                src = encode(current_image)
                            )
                        ]
                    )
                ]
            ),
            html_div(
                id = "filter-div",
                [
                    dcc_dropdown(
                        id = "filter-dropdown",
                        options = [(label = f, value = f) for f in filters_names],
                        value = default_filter,
                        clearable = false
                    )
                ]
            ),
            html_div(
                id = "output-div",
                html_div(
                    id = "output-viewer-wrapper",
                    className = "viewer-wrapper",
                    [
                        html_img(
                            id = "output-viewer",
                            className = "viewer",
                            src = encode(current_image)
                        )
                    ]
                )
            )
        ]
    ),
    html_div(
        id = "bench-div",
        [
            html_h4("Temps d'exécution"),
            html_div(
                id = "bench-subdiv",
                [
                    html_div(
                        className = "bench",
                        [
                            html_p("julia"),
                            html_p(id = "bench-julia", "0 seconde(s)")
                        ]
                    ),
                    html_div(
                        className = "bench",
                        [
                            html_p("Python"),
                            html_p(id = "bench-python", "0 seconde(s)")
                        ]
                    ),
                    html_div(
                        className = "bench",
                        [
                            html_p("R"),
                            html_p(id = "bench-r", "0 seconde(s)")
                        ]
                    )
                ]
            )
        ]
    )
end

# server side callbacks
callback!(
    app,
    Output("input-viewer", "src"),
    Input("input-dropdown", "value"),
) do file_name
    current_image = testimage(file_name)
    return encode(current_image)
end

callback!(
    app,
    Output("output-viewer", "src"),
    Output("bench-julia", "children"),
    Input("input-dropdown", "value"),
    Input("filter-dropdown", "value"),
) do file_name, filter_name
    current_image = testimage(file_name)
    time = 0
    if filter_name == "identité"
        image = encode(current_image)
    elseif filter_name == "fabio"
        image = encode(testimage("fabio_color_512"))
    elseif filter_name == "julia"
        image = encode(load("assets/julia.png"))
    elseif filter_name == "Python"
        image = encode(load("assets/Python.jpg"))
    elseif filter_name == "R"
        image = encode(load("assets/R.jpg"))
    else
        result = ImageProcessing.apply_filter(current_image, filter_name, "julia")
        image = encode(result[1])
        time = result[2]
    end
    return image, string(time, " seconde(s)")
end

run_server(app, "0.0.0.0", debug = true)
