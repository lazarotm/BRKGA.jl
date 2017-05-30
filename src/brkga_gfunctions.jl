
function initialize_population( current, previous, K, p, n, teto, chao, func )	
	
	# Initialize and decode each chromosome of the current population, then copy to previous:
	for i = 1:p
		for j = 1:n
			previous[K].population[i,j] = current[K].population[i,j] = rand()			
		end
	end


	for j = 1:p
		x = get_solution(teto,chao,current[K].population[j,:])

		setFitness(j, abs(func(x)),K,current)
		setFitness(j, abs(func(x)),K,previous)
	end

	sortFitness_BRKGA!(current, K)
	sortFitness_BRKGA!(previous, K)		
end

function setFitness(a, b, i, current)
	current[i].fitness_first[a] = b
	current[i].fitness_second[a] = a
end

function get_solution( teto, chao, new )

	for a = 1: length(new)		
		new[a] = ( new[a] * (teto[a] - chao[a]) ) + chao[a]
	end

	return new 

end 

function getBestFitness_final( current, K, teto, chao )

	best = current[1].fitness_first[1]
	aux_best = 1

	for i = 1:K
		if current[i].fitness_first[1] < best
			best = current[i].fitness_first[1]
			aux_best = i
		end
	end	

	print("best value: ")
	println(best)

	print("chromosome: ")
	println(current[aux_best].population[current[aux_best].fitness_second[1],:])

	print("K: ")
	println(aux_best)

	variables = get_solution(teto,chao,current[aux_best].population[current[aux_best].fitness_second[1],:])

	print("solution: ")
	println(variables)

	println()
	println()
end

function get_fitness(x)
	
	n = length(x)

	summation1 = -20 * exp(-0.2 * sqrt( sum(x.*x) / n ))
	summation2 = exp(sum(map(cos,*(x,2,pi))) / n )
	return summation1 - summation2 + 20 + e
	
	fitness = ( x[1] + (2*x[2]) - 7 )^2 + ( (2*x[1]) + x[2] - 5 )^2

	return abs(fitness)	
end

function evolution_BRKGA(curr, next, K, pe, pm, n, p, rhoe, teto, chao, func)

	
	#println("cheguei no 1")
	# 1. We now will set every chromosome of 'current', iterating with 'i':
	i = 1	# Iterate chromosome by chromosome
	j = 1	# Iterate allele by allele

	#println("cheguei no 2")

	# 2. The 'pe' best chromosomes are maintained, so we just copy these into 'current':
	while i <= pe # LIMITE ALTERADO		
		for j = 1:n
			next[K].population[i,j] = curr[K].population[curr[K].fitness_second[i],j]
		end

		next[K].fitness_first[i] = curr[K].fitness_first[i]
		next[K].fitness_second[i] = i

		i = i + 1		
	end


	#println("cheguei no 3")

	# 3. We'll mate 'p - pe - pm' pairs; initially, i = pe, so we need to iterate until i < p - pm:
	while i <= p - pm # LIMITE ALTERADO
		# Select an elite parent:
		eliteParent = Int(rand(1:pe)) # LIMITE ALTERADO

		# Select a non-elite parent:
		noneliteParent = Int(pe + rand(1:p - pe)) # LIMITE ALTERADO

		#println(eliteParent)
		#println(noneliteParent)

		# Mate:
		for j = 1:n
			sourceParent = (rand(Float32) < rhoe) ? eliteParent : noneliteParent
			next[K].population[i,j] = curr[K].population[curr[K].fitness_second[sourceParent],j]
		end

		i = i + 1
	end

	#println("cheguei no 4")


	# 4. We'll introduce 'pm' mutants:
	while i <= p # LIMITE ALTERADO
		for j = 1:n
			next[K].population[i,j] = rand()
		end
		i = i + 1
	end

	curr[K]

	#println("cheguei no 5")

	# 5. Time to compute fitness, in parallel:
	#@acc begin	
	Threads.@threads for i = pe:p
		i = Int(i)
		x = get_solution(teto,chao,next[K].population[i,:])
		setFitness(i, abs(func(x)),K,next) 
	end
	#end

	#println("cheguei no 6")

	# 6. Now we must sort 'current' by fitness, since things might have changed:
	sortFitness_BRKGA!(next, K)
end

function sortFitness_BRKGA!(curr, K)
	index = sortperm(curr[K].fitness_first) # computing a permutation of the array’s indices.
	curr[K].fitness_first = curr[K].fitness_first[index] # reorganiza o vetor de acordo com os novos indices.
	curr[K].fitness_second = curr[K].fitness_second[index] # reorganiza o vetor de acordo com os novos indices.
end

function evolve_BRKGA(curr, previous, K, pe, pm, n, p, rhoe, generations, teto, chao, func)
	for i = 1:generations
		for j = 1:K
			evolution_BRKGA(curr, previous, j, pe, pm, n, p, rhoe, teto, chao, func)
		end
	end
end

function exchangeElite_BRKGA( M, K, current, p )
	
	for i = 1:K
		# Population i will receive some elite members from each Population j below:
		dest = p ; # Last chromosome of i (will be updated below) # LIMITE ALTERADO

		for j = 1:K

			if i != j
				# Copy the M best of Population j into Population i:
				for m = 1:M
					# Copy the m-th best of Population j into the 'dest'-th position of Population i:
					bestOfJ = current[j].population[current[j].fitness_second[m],:]

					current[i].population[dest,:] = bestOfJ
					current[i].fitness_first[dest] = current[j].fitness_first[m]

					dest = dest - 1
				end
			end
		end
	end
end

function getBestFitness( current, K )

	best = current[1].fitness_first[1]

	for i = 1:K
		if current[i].fitness_first[1] < best
			best = current[i].fitness_first[1]
		end
	end

	return best
end