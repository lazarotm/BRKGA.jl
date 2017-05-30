
type Population
	population::Array{Float32,2} # Population as vectors of prob.
	fitness_first:: Array{Float32,1} # Fitness (double) of a each chromosome
	fitness_second:: Array{UInt16,1}
end