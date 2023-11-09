module FactoryMethodPattern

using Printf

"""
format(::Formatter, x::T) where {T <: Number}

Format a number `x` using the specified formatter.
Returns a string.
"""
function format end

abstract type Formatter end
struct IntegerFormatter <: Formatter end
struct FloatFormatter <: Formatter end

formatter(::Type{T}) where {T <: Integer} = IntegerFormatter()
formatter(::Type{T}) where {T <: AbstractFloat} = FloatFormatter()
formatter(::Type{T}) where {T} = error("No formatter defined for type $T")

format(::IntegerFormatter, x) = @sprintf("%d", x)
format(::FloatFormatter, x) = @sprintf("%.2f", x)

end
