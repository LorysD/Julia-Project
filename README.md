# Julia-Project

In this project we compare the time taken by `Julia`, `R` and `Python`
to perform a convolution for a given image and a given filter. There are
8 filters one can apply on an image among which :

- `Identity filter`
- `Selective Blur filter`
- `Embossing filter`

The images used in this project are ones available in the package `TestImage`.

This project is composed of two parts

- `DashApp`: The dash application used to display the time taken by the three languages to apply the filter over the image
- `ImageProcessing`: The package used to apply the filter over an image in `Julia`, `Python` and `R`. This package also provides functions to measure the execution time.

# Installation

To install the package go to **ImageProcessing** and open **julia-repl** than run the following commands

```julia-repl
julia> ]
julia> activate .
julia> build ImageProcessing
```




