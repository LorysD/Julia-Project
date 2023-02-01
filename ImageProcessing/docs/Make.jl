push!(LOAD_PATH,"../src/")
include("../src/measurement.jl")
include("../src/ImageProcessing.jl")
using Documenter

makedocs(
	 sitename="ImageProcessing documentation",
	 modules=[Measurement, ImageProcessing],
	 pages=[
		"Home" => "index.md",
		]
	 )


