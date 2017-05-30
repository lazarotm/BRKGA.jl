
function main(;n=2,p=100, pe=0.30, pm=0.20, rhoe=0.70, K=3,X_INTVL=100, X_NUMBER=2, MAX_GENS=1000, N_Evolutions=1, teto=10, chao=-10,fn="booth", efn="")

	if efn != ""
		func = include(efn)
		println("\nUtilizando função externa: ")
	else
		func = eval(parse(fn))
		println("\nUtilizando função interna: ")
	end

	println(typeof(func))

	current = Array{Population}(K)
	previous = Array{Population}(K)

	generation = 0	

	rngSeed = 0	# seed to the random number generator
	srand(rngSeed) # initialize the random number generator

	pe = pe * p
	pm = pm * p

	teto = fill(10,n)
	chao = fill(-10,n)

	for i = 1:K
		# Allocate Population:
		current[i] = Population(fill(0,p,n),fill(0,p), fill(0,p))
		previous[i] = Population(fill(0,p,n),fill(0,p), fill(0,p))
		# Initialize Population:
		initialize_population( current, previous, i, p, n, teto, chao,func)
	end


	while generation < MAX_GENS
		evolve_BRKGA(current, previous, K, pe, pm, n, p, rhoe, N_Evolutions, teto, chao, func)
		current,previous = previous,current

		if generation % X_INTVL == 0
			exchangeElite_BRKGA( X_NUMBER, K, current, p )
		end

		generation = generation + 1
	end

	best_fitness = getBestFitness_final(current, K, teto, chao)


end
