Chromatic-Project
=================

Chromatic Orb Probability Project
---------------------------------

1. Why care about chromatic orbs?
	Like many currency items in Path of Exile, chromatic orbs operate in a probabilistic fashion. Although chromatics are not an expensive item, rolling the proper set of colors on an item can sometimes take hundreds or thousands of chromatics. In order to better estimate how many chromatics are necessary for a desired roll, we need to understand the way in which PoE implements chromatic orbs. To date, there has been no systematic study of this function.
	
2. What do we know about chromatic orbs?
	We know that chromatic orbs reroll the colors of the sockets on an item. It seems to reroll the colors of every socket, rather than just a single socket. We know that the only outcome which is impossible is for the colors to remain exactly the same (with each socket remaining the exact same color). We also know that the probability of any color socket is weighted (in some fashion) by the stat requirements of the item, high STR means more red sockets, high INT more blue, high DEX more green. I believe the devs have confirmed that this is based on the stat requirement after any reduced stat requirement modifiers on the item are taken into account.
	
	We also know a lot about how PoE implements probability rolls in general. Every option is given an integer weighting. The actual probability is then the weight divided by the sum of weights for all possible outcomes.
	
3. So how do we figure out the function?
	Our best tool for discovering how chromatics work is to come up with testable theories. I propose the following function:
	
	a) Each socket is rolled individually
	b) The probability of any color is based ONLY on the item's stat requirements and a hidden parameter X
	c) The probability distribution for each socket is identical (i.e. we have iid draws)
	d) The probability of any color follows the following function. The idea being that the weight for each color is simply the sum of that color's stat requirement and the hidden parameter X. We derive probabilities by dividing by the sum of all weights, which in this case would be the sum of the stat requirements plus 3X.
		p_color = (associated_stat_req + X) / (sum(all_stat_reqs) + 3*X)
	e) A roll is made and compared against the weights for each color, determining the color of that socket.
	f) This process is repeated for all sockets
	g) A final check is performed to see if the socket colors have changed. If they have not, the process is repeated again in full until the item has a different set of socket colors
	
4. How do we know this is true?
	We have two ways of testing any theory such as this. The first is model selection. If we have multiple theories, we can compare them against the data and against their inherent complexity (e.g. in terms of number of parameters needed) and determine which theory fits the data most elegantly. Currently there are no competing theories. The other way to test is to make predictions from the model and test them against the actual data. Perhaps the simplest statistical test would in this case be a Chi-Square goodness-of-fit test. This test compares observed counts for different outcomes against the relevant expected counts in order to determine whether or not the observed data is significantly different from the expectations.
	
5. Ok, we have our theory. But how do we find out what X is?
	Determining hidden parameter values is a well-researched area in Machine Learning. This type of task ends up being relatively trivial. Although we could use any manner of parameter-fitting techniques, my background is in Bayesian graphical modeling. Therefore I've opted to use a simple Metropolis-Hastings sampler. This type of algorithm performs a random walk over the hypothesis space and as you let the model sample more and more values of X, that distribution of samples will converge on the true distribution of values for X (i.e. with enough time it will converge on the optimal value of X). When I mention a hypothesis space, what I mean is the set of possible values of X. In this case the full hypothesis space would be the set of all integers >= 0. In practice, I've limited the value between 0 and 100, and I've allowed for non-integer values in that range. The decision to include non-integers is simply to allow myself to see how confident the model is as well as to test the pre-conceived notion we have that the value of X is an integer.
