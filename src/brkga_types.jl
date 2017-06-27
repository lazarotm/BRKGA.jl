
type Population
	population::Array{Float64,2} # Population as vectors of prob.
	fitness_first:: Array{Float64,1} # Fitness (double) of a each chromosome
	fitness_second:: Array{UInt16,1}
end