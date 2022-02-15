module LUComptonScatter

import LinearAlgebra
import DataFrames
import Findpeaks
import Smoothers
import Interpolations

include("analysisFuncs.jl")

export expected_energy
export read_Txt
export get_xy_data
export select_part
export weighted_mean
export find_peak_ends
export peak_parameters
export get_peak_value
export gauss
export fit_to_gauss

include("chiSquredFitting.jl")

export χ²
export compton
export scan
export scan_box

end # module
