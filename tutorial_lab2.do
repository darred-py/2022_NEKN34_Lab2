clear
cd "C:\Users\pe5220al\OneDrive - Lund University\Office Laptop\Teaching\Time Series Analysis\VT2023\Lab 2" // can also do it from the menubar under 'file'

import delimited "C:\Users\pe5220al\OneDrive - Lund University\Office Laptop\Teaching\Time Series Analysis\VT2023\Lab 2\ExchangeRate", varnames(1)

// Format existing time varaible
gen t=date(date,"MDY") //converts to days since 1960 (some date)
format t %td
tsset t, daily // this will mean that you have missing values when you create the required variable 


tsset, clear
drop t

// Create new time variable, lazy version
gen t = _n
tsset t


// daily returns (as a percentage) of nominal exchange rate on a continuously compounding basis
gen y =log(value/l.value)*100

corrgram y, lags(10) //autocorrelation, we know how to model that from Lab 1


*Engle two-step testing procedure, ARCH effects
regr y
estat archlm, lags(1/10)


*ARCH 
arch y, arch(1)

*GARCH
arch y, arch(1) garch(1) 
test [ARCH]L.arch + [ARCH]L.garch == 1 // wald test (composite linear hypothesis)

*GARCH in mean (conditional variance in mean equation - X where you conditional variance should be)
arch y, arch(1) archm 
arch y, arch(1) archm archmexp(sqrt(X)) //enters exponentially

*ExponentialGARCH
arch y, earch(1) egarch(1) 
// earchL1 <- \alpha_1 ("asymmetry parameter"), \alpha_11 in help file
//earch_aL1. <- \alpha_2 ('size parameter'), \gamma_11 in the help file 
//egarchL1. <- \beta_1 (lagged ln(h_t)), \alpha_12 in the help file

*IntegratedGARCH
constraint 1 [ARCH]L1.arch + [ARCH]L1.garch == 1
arch y, arch(1) garch(1) constraints(1)

*APARCH
arch y, aparch(1) garch(1) 

//example to subset pre estimation: keep if t>6577 & t<12599 or add as option when estimating




*Distribution tests
**Jarque-Bera test (normal)
sktest y
**Shapiro-Wilke test (normal)
swilk y


**Kolmogorov-Smirnov test (any distribution)
*ksmirnov er = t(4,er) // student t(4) degrees of freedom
*ksmirnov er = normal((er-mean(er))/varinace(er))  // normal dist

*ARCH/GARCH adjusting for non-normally distributed errors
arch y, arch(1) garch(1) distribution(t 3)
arch y, arch(1) garch(1) distribution(ged 2) // generalized error distribution


// configuring the (p,q) <- same idea as arma 

//achieved by subtracting the mean from each observation in the series and squaring the result, or just squaring the observation if you're already working with white noise residuals from another model.


