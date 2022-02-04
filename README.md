# Lawrence University Compton Scattering Experiment

This package includes functions for use in the analysis of compton scattering data for an experiment at Lawrence University. 

## Installation 

In order to install this package run the following in the `julia` REPL

```julia
julia> using Pkg

julia> Pkg.add(url="https://github.com/lvb5/LUComptonScatter.git")
```
Each function is well documented. To get help on a certain function, type ? then the function's name. 

## Example

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
result = get_peak_value(x0, y0, peaks[1])
```
A plot of the raw data and the smoothed data with extreme points located are shown below

<img src="https://github.com/lvb5/LUComptonScatter/blob/master/examples/plot1.png" width="200"/> <img src="https://github.com/lvb5/LUComptonScatter/blob/master/examples/plot2.png" width="200"/>
