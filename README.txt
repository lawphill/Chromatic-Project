Chromatic Orb Probability Project
---------------------------------

For more information about the details of the project, please consult the AboutChromatics.txt file or visit the main forum post (http://www.pathofexile.com/forum/view-thread/761831/).

In order to run the files over your own set of data, follow these steps:

1) Save your data as a .xlsx spreadsheet in the DataFiles folder

2) Open MATLAB and run chromatic_sampler.m, this will use the Metropolis-Hastings algorithm to estimate the value of X

3) In MATLAB run expected_chromes.m, this determines what we should expect the data to look like given the underlying model

4) Run ChromeChiSquare.m, this tests the observed data versus the expected data in a number of different ways

5) The data struct 'd' contains information about the sampling procedure
	The data struct 'hist' contains information about the observed and expected counts that we're testing
	The data struct 'p' contains information about the statistical tests about those counts
	
Other files:
chrome_probs.m calculates the log likelihood for any given dataset