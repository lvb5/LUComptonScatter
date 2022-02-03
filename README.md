# Lawrence University Compton Scattering Experiment

This package includes functions for use in the analysis of compton scattering data for an experiment at Lawrence University. 

## Installation 

This package requires a standard `julia` installation. In order to install this package run the following in the `julia` REPL

```julia
julia> using Pkg

julia> Pkg.add(url="https://github.com/lvb5/LUComptonScatter.git")
```

You can then import this package and use its functions by

```julia
julia> using LUComptonScatter

julia> expected_energy(10, 661)
648.2605072385865
```

Each function is well documented. To get help on a certain function, type ? then the function's name. 

## Usage
