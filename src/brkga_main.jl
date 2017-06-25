
function main(;n=2,p=100, pe=0.30, pm=0.20, rho=0.70, K=3,X_INTVL=100, X_NUMBER=2, it=0, N_Evolutions=1, dm=[0,0], dmu=[0,0], dml=[0,0], ifn="booth", efn="",sd=270001,of="output.txt", ep=0)

	time = time_ns()
	
	func = parse_function_name( efn, ifn )
	teto, chao = parse_bounds( dm, dmu, dml, n )
	it_or_ep = 

	current = Array{Population}(K)
	previous = Array{Population}(K)

	generation = 0	

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

	while ( parse_it_or_ep(it, ep, generation, currentFitness) )

		evolve_BRKGA(current, previous, K, pe, pm, n, p, rho, N_Evolutions, teto, chao, func)
		current,previous = previous,current
		
		currentFitness = getBestFitness_current( current, K, teto, chao )

		if oldFitness != currentFitness

			@printf "\n[%d] time: %.5f seconds\n" generation+1 ( ( time_ns() - time ) / 1000000000 )
			getBestFitness_final(current, K, teto, chao)
			
		end

		if generation % X_INTVL == 0
			exchangeElite_BRKGA( X_NUMBER, K, current, p )
		end

		oldFitness = currentFitness
		generation = generation + 1
	end

end
