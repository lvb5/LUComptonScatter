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
export remove_missing
export find_peak_ends
export peak_parameters
export get_peak_value

end # module
