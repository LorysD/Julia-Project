# Julia-Project

In this project we compare the time taken by `Julia`, `R` and `python`
to perform a convolution for a given image and a given filter. There are
3 filters one can apply on an image among which :

- `Identity filter`
- `Selective Blur filter`
- `Embossing filter`

This project is composed of two parts

- `DashApp`: The dash application used to display the time taken by the three languages to apply the filter over the image
- `ImageProcessing`: The package used to apply the filter over an image in `Julia`, `python` and `R`. This package also provides functions to measure the execution time.

## Dash application

We used `Dash` (https://dash.plotly.com/), a cross language framework for small "data apps", to give the user the choice of the image and the filter to apply.
`Dash` provide a callback mechanism for communication between the client and the server side, as `Shiny` does.
Unfortunately its `Julia` documentation is not as rich as the `python` one and the `Julia` implementation still lacks some functionalities.

The workflow is quite simple. 
When a filter is selected from the dropdown list, the corresponding matrix is displayed and 3 calls (one per language) are issued to the server side to compute the resulting image.
Due to the lack of documentation, we did not manage to understand if the calls were run entirely concurrently, but we think that it is not. 
As soon as the `Julia` call has ended the result is shown, and the computation times are updated as the calls finished.

## ImageProcessing

Since we wanted to compare performances of the different languages we avoided the use of `python` or `R` libraries relying on `C++` implementations.
However, we used some `Julia` packages:

- `TestImage` to provide images examples,
- `Images` to ease the use of the `TestImage`,
- `PyCall` to call external `python` scripts,
- `RCall` for `R` scripts.

The convolution implementation is the same for the 3 languages and is really naive.

# Quick start

## Dependencies

```julia-repl
julia> ENV["PYTHON"]=""
julia> ]
pkg> add Dash FileIO Images ImageShow Plots TestImages
pkg> add PyCall RCall
pkg> build PyCall
```

## Running the Dash app

```bash
$ cd DashApp
$ julia app.jl
```


## Documentation

```julia-repl
julia> ]
pkg> add Documenter
```

You can generate the documentation associated to the project by setting the current directory to `ImageProcessing` and running the following bash command

```bash
$ cd ImageProcessing
$ julia docs/Make.jl
```

# Feedback

We were really impressed by the speed of `Julia` in comparison to `python` or `R`, even if it was expected.

The possibility to use composite types (such as `Matrix`) without specifying the type of its elements (as we did with the function `apply_filter`) is also really appreciable as it allows to retain the "non-typed" versatility and ease of coding while giving compiled languages performances through JIT when a new argument type is encountered.

To us, the documentation is sometime a bit too light, and as the community is not that big (for the moment?) it is sometime a bit difficult to find answers to some issues (especially true for the `Dash` part).
