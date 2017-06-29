
function main(;n=2,p=100, pe=0.30, pm=0.20, rho=0.70, K=3,X_INTVL=100, X_NUMBER=2, it=-1, N_Evolutions=1, dm=[0,0], dmu=[0,0], dml=[0,0], ifn="booth", efn="",sd=270001, of="none", ep=1.0e-10, generation=0, ter=1)

	time = time_ns() #variável para armazenar o tempo de processamento	

	outputFile = [""]
	if( of != "none")	
		stream = open(of, "w")
	end
	
	func = parse_function_name( efn, ifn )
	teto, chao = parse_bounds( dm, dmu, dml, n )
	cont = 0
	
	current = Array{Population}(K)
	previous = Array{Population}(K)	

	srand(sd) # initialize the random number generator

	pe = pe * p
	pm = pm * p

	for i = 1:K
		# Allocate Population:
		current[i] = Population(fill(0,p,n),fill(0,p), fill(0,p))
		previous[i] = Population(fill(0,p,n),fill(0,p), fill(0,p))
		# Initialize Population:
		initialize_population( current, previous, i, p, n, teto, chao,func)
	end

	oldFitness = getBestFitness_current( current, K, teto, chao )
	currentFitness = getBestFitness_current( current, K, teto, chao )

	while ( parse_it_or_ep(it, ep, cont, currentFitness) )

		evolve_BRKGA(current, previous, K, pe, pm, n, p, rho, N_Evolutions, teto, chao, func)
		current,previous = previous,current
		
		currentFitness = getBestFitness_current( current, K, teto, chao )

		if ( oldFitness != currentFitness || generation == 0 )

			if ter == 1
				@printf "generation: %d\ntime: %.5f seconds\n" (generation+1) ( ( time_ns() - time ) / 1000000000 )
				getBestFitness_final(current, K, teto, chao, ter)
			end

			if( of != "none")
				cont = 0

				push!(outputFile,"generation: $(generation+1)\ntime: $( ( time_ns() - time ) / 1000000000 ) seconds\n" )
				push!(outputFile,getBestFitness_final(current, K, teto, chao, ter))
			end
		end



		if generation % X_INTVL == 0
			exchangeElite_BRKGA( X_NUMBER, K, current, p )
		end

		oldFitness = currentFitness
		generation = generation + 1
		cont = cont + 1
	end

	@printf "\nLast generation: %d\n" (generation-1)


	if( of != "none")	
		write(stream, outputFile)
		close(stream)
	end
	
end