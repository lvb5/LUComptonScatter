using LUComptonScatter, Plots

#function determined from calibration
f(x) = 0.669462 * x + 55.3071

data = read_Txt("examples/exampleData.Txt")
x0, y0 = get_xy_data(data, 100, f)

# Plot raw data
plot(x0, y0, label = "data", xlabel = "Energy [keV]", ylabel = "Counts", legend=:topleft)

# extract smoothed curve and peak data
peaks, ySmooth = peak_parameters(x0, y0, 25, 1000.0, 0.5)

#plot this new data
plt = plot(x0, ySmooth, label = "data", xlabel = "Energy [keV]", ylabel = "Counts", legend=:topleft)
for i in 1:length(peaks)
    scatter!(x0[peaks[i]], ySmooth[peaks[i]], label = "Peak Data $i")
end
display(plt)

##extract value of peak
result = get_peak_value(x0, y0, peaks[1])