# ImageProcessing

Welcome to the documentation of `ImageProcessing` package.
This page describes the two main julia modules of this package :
- The `Measurement` module
- The `ImageProcessing` module

# Measurement module

The `Measurement` modules provides two functions to perform measurements for functions.

- **compute\_execution\_time**: Computes the execution time of a given function
- **compute_allocation**: Computes the allocated memory to execute a function

```@docs
Measurement.compute_execution_time
```


```@docs
Measurement.compute_allocation
```

# ImageProcessing module

The `ImageProcessing` modules provides several functions to apply filters

- **jl\_apply\_filter**: Apply a filter to an image using julia
- **py\_apply\_filter**: Apply a filter to an image using python
- **r\_apply\_filter**: Apply a filter to an image using r
- **img\_to\_arr**: Convert and RGB matrix to a Float64 matrix
- **get\_filter**: Returns the matrix corresponding to a filter name
- **apply\_filter**: Apply filter to an image using a language

```@docs
ImageProcessing.jl_apply_filter
```


```@docs
ImageProcessing.py_apply_filter
```

```@docs
ImageProcessing.r_apply_filter
```


```@docs
ImageProcessing.img_to_arr
```

```@docs
ImageProcessing.get_filter
```

```@docs
ImageProcessing.apply_filter
```

```@docs
ImageProcessing.conv
```
