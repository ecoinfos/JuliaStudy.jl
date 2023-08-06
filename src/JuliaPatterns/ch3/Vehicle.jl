module Vehicle

# 1. Export/Imports
export go!

# 3. Generic definitions for the interface

"""
    power_on!

turn on the vehicle's engine
"""
function power_on! end

"""
    power_off!

turn off the vehicle's engine
"""
function power_off! end

"""
    turn!

steer vehicle to the specified direction
"""
function turn! end

"""
    move!

move the vehicle by the specified distance
"""
function move! end

"""
    position

returns the (x, y) position of the vehicle
"""
function position end

"""
    engage_wheels(args...)

engage wheels for  landing. Optional
"""
engage_wheels!(args...) = nothing

# 4. Game logic

"""
    travel_path(position, destination)

Returns a travel plan from current position to destination
"""
function travel_path(position, destination)
  return round(π / 6, digits = 2), 1000   # just a test
end

function go!(vehicle, destination)
  power_on!(vehicle)
  direction, distance = travel_path(position(vehicle), destination)
  turn!(vehicle, direction)
  move!(vehicle, distance)
  power_off!(vehicle)
  nothing
end

function land!(vehicle)
  engage_wheels!(vehicle)
  println("Landing vehicle: ", vehicle)
end

# trait
has_wheels(vehicle) = error("Not implemented.")

"""
    land2!(vehicle)

Landing (using trait)
"""
function land2!(vehicle)
  has_wheels(vehicle) && engage_wheels!(vehicle)
  println("Landing vehicle: ", vehicle)
end


end
