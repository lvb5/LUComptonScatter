# Lawrence University Compton Scattering Experiment

This package includes functions for use in the analysis of compton scattering data for an experiment at Lawrence University. 

## Installation 

In order to install this package run the following in the `julia` REPL:

```
julia> using Pkg

julia> Pkg.add(url="https://github.com/lvb5/LUComptonScatter.git")
```

or use the package manager by typing "]" in the REPL and then

```
pkg> add https://github.com/lvb5/LUComptonScatter.git
```

Each function is well documented. To get help on a certain function, type ? then the function's name. 

## Dependencies

This package requires the following additional packages:

- `DataFrames.jl`
- `Findpeaks.jl`
- `Interpolations.jl`
- `LsqFit.jl`
- `Smoothers.jl`

`Findpeaks.jl` must be downloaded from the [GitHub page](https://github.com/tungli/Findpeaks.jl).

## Peak Finding

Say we take a set of data and want to perform some analysis of it. The following code performs a standard analysis of a data sample

```julia
using LUComptonScatter, Plots

#function determined from calibration
f(x) = 0.669462 * x + 55.3071

data = read_Txt("/path/to/file.Txt")
x0, y0 = get_xy_data(data, 100, f)

# Plot raw data
plot(x0, y0, label = "data", xlabel = "Energy [keV]", ylabel = "Counts", legend=:topleft)

# extract smoothed curve and peak data
peaks, ySmooth = peak_parameters(x0, y0, 25, 1000.0, 0.5)

#plot this new data
plt = plot(x0, ySmooth, label = "data", xlabel = "Energy [keV]", ylabel = "Counts", legend=:topleft)
for i in 1:length(test)
    scatter!(x0[test[i]], ySmooth[test[i]], label = "Peak Data $i")
end
display(plt)

##extract value of peak
result, error = fit_to_gauss(x0, y0, peaks[1])
result[3], error[3]
```
Plots of the raw data and the smoothed data with extreme points located are shown below

<img src="https://github.com/lvb5/LUComptonScatter/blob/master/examples/plot2.png" width="300"/> <img src="https://github.com/lvb5/LUComptonScatter/blob/master/examples/plot1.png" width="300"/> 

The value returned by `fit_to_gauss()` is a vector containing the fit parameters and their uncertainty. Notice that this uncertainty will be relatively small. Most uncertainty comes from calibration of the instrument. This is generally the value we care about when analyzing data from the detector. 

## Data Fitting 

Once we have found peak energies for various scattering angle, we wish to fit this to the compton formula. This is accomplished using a reduced chi squared method. An example to implement this is shown below 

```julia
using CSV, DataFrames, Plots, LaTeXStrings, LUComptonScatter

df = DataFrame(CSV.File("/path/to/data.csv"))
x = df[!,1]
y = df[!,2]

#inverse of fit function, to go from energy to channel
f_inverse(x) = (x + 0.1221) / 0.739
#calculate uncertainty from uncertainty propogation
energy_uncertainty(x) = sqrt((0.02627 * x)^2 + 16.4079^2)
#get them uncerainty values in energy
σy = energy_uncertainty.(f_inverse.(y))

#compute paramters and error from reduced chi^2
E, σE, m, σm, chiSq = scan_box(610.0, 700.0, 460.0, 540.0, x, y, σy, 0.08)

println("E = $E ± $σE; mₑ = $m ± $σm") #print result

#data for fit plotting
xFit = LinRange(0, x[length(x)], 1000)
yFit = compton(xFit, [E, m])
chiOut = round(chiSq, digits=2)

#plot results
scatter(x, y, yerror = σy,
        label = "Data", 
        xlabel = "Scattering Angle [degrees]", 
        ylabel = "Energy [keV]", 
        dpi = 500, size = (350, 350))
plot!(xFit, yFit, label = L"Fit: $\chi^2/\textrm{dof} = %$chiOut$")
```
This produces the following plot

<img src=https://github.com/lvb5/LUComptonScatter/blob/master/examples/scatteredPlotEg.png width="400">

and paramters E = 657.8125 ± 2.8125, mₑ = 517.5 ± 2.5 which agree with expected values within three standard deviations. 
