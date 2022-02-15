"""
    χ²(y::Vector, μ::Vector, σ::Vector)

Calculate reduced χ² of calculated values `y` with 
uncertainty `σ` in comparision to expected values `μ`
"""
χ²(y::Vector, μ::Vector, σ::Vector) = sum((y .- μ).^2 ./ σ.^2)

"""
    compton(θ, p)

Compute compton energy at angle `θ` with initial energy `p[1]`
and electron rest mass `p[2]`. 
"""
@. compton(θ, p) = p[1] * (1 / (1 + ((p[1]/p[2])*(1 - cos(θ * (π / 180))))))

"""
    scan(startE::Float64, stopE::Float64, startM::Float64, 
        stopM::Float64, xData::Vector, yData::Vector, yError::Vector)

Compute chi squared values over a grid in parameter space defined by 
`startE`, `stopE`, `startM`, and `stopM`. This returns the new parameters, 
a chi squared value for these parameters, and a new, smaller space to cover. 
"""
function scan(startE::Float64, stopE::Float64, startM::Float64, stopM::Float64, xData::Vector, yData::Vector, yError::Vector)
    #define box
    stepSizeE = (stopE - startE) / 4
    stepSizeM = (stopM - startM) / 4

    #initialize values
    chiSq = Inf64
    E = 0.0
    mₑ = 0.0
    newEstart = Inf64
    newEend = Inf64
    newMstart = Inf64
    newMend = Inf64

    # at each step, take the mid point and calculate the chi^2 value
    # Then, compare it to other values. If it's less, update E and m_e
    for i in 1:4
        for j in 1:4
            #get parameters from box
            p1 = (startE + stepSizeE * i) - 0.5 * stepSizeE
            p2 = (startM + stepSizeM * j) - 0.5 * stepSizeM
            params = [p1, p2]

            #calculate chi^2
            expected = compton(xData, params)
            chiSqTest = χ²(yData, expected, yError)

            #if claculated value is less than previous, update E and m
            if chiSqTest < chiSq
                chiSq = chiSqTest
                E = p1
                mₑ = p2
                newEstart = startE + stepSizeE * (i - 1)
                newEend = newEstart + stepSizeE
                newMstart = startM + stepSizeM * (j - 1)
                newMend = newMstart + stepSizeM
            end
        end
    end
    return E, mₑ, newEstart, newEend, newMstart, newMend, chiSq
end

"""
    scan_box(startE1::Float64, stopE1::Float64, startM1::Float64, 
            stopM1::Float64, xData::Vector, yData::Vector, yError::Vector, tol::Float64)

Find best fit parameters and their errors and compute χ² given the parameters. 

Require an upper limit of χ² of `tol::Float64`.
"""
function scan_box(startE1::Float64, stopE1::Float64, startM1::Float64, stopM1::Float64, xData::Vector, yData::Vector, yError::Vector, tol::Float64)

    #initialize values
    E, m, chiSq = Inf64, Inf64, Inf64
    dof = length(xData) - 2
    startE = startE1
    stopE = stopE1
    startM = startM1
    stopM = stopM1

    # keep computing until desired tolerance is reseach 
    counter = 0
    while (chiSq / dof) > tol && counter < 10
        E, m, startE, stopE, startM, stopM, chiSq = scan(startE, stopE, startM, stopM, xData, yData, yError)
        counter += 1
    end

    #compute error
    σE = (stopE - startE) / 2
    σM = (stopM - startM) / 2

    return E, σE, m, σM, chiSq/dof
end