"""
    sphere_volume(r)

Calculate the volume of a sphere with radius `r`
"""
function sphere_volume(r::Number)
  4π * r^3 / 3
end

"""
    cylinder_volume(r, h)

Calculate the volume of a cylinder with radius `r` and height `h`.
"""
function cylinder_volume(r::Number, h::Number)
  π * r^2 * h
end

"""
    cone_value(r, h)

Calculate the volume of a cone with radius `r` and height `h`.
"""
function cone_value(r::Number, h::Number)
  π * r^2 * h / 3
end
