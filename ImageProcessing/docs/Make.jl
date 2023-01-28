push!(LOAD_PATH,"../src/")
include("../src/measurement.jl")
using Documenter

makedocs(
	 sitename="ImageProcessing documentation",
	 modules=[Measurement],
	 pages=[
		"Home" => "index.md",
		]
	 )


