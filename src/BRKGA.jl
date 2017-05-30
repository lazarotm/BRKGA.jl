
module brkga_module
#Pkg.update()

include("brkga_types.jl")
include("brkga_gfunctions.jl")
include("brkga_functions_samples.jl")
include("brkga_main.jl")
include("brkga_parser.jl")

#functions and variables exported
export main,n, p, pe, pm, rhoe, K, MAXT, generation,
X_INTVL, X_NUMBER, MAX_GENS, N_Evolutions

end

