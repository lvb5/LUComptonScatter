using CSV, DataFrames, Plots, LaTeXStrings, LUComptonScatter

df = DataFrame(CSV.File("examples/exampleScatter.csv"))
x = df[!,1]
y = df[!,2]
#inverse of fit function, f to energy
f_inverse(x) = (x + 0.1221) / 0.739
#calculate uncertainty from propogation
energy_uncertainty(x) = sqrt((0.02627 * x)^2 + 16.4079^2)
#get them uncerainty values in energy
σy = energy_uncertainty.(f_inverse.(y))

E, σE, m, σm, chiSq = scan_box(610.0, 700.0, 460.0, 540.0, x, y, σy, 0.08)

println("E = $E ± $σE; mₑ = $m ± $σm")

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
plot!(xFit, yFit, label = L"Fit: $\chi^2/dof = %$chiOut$")
