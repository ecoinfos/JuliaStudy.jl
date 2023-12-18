module DefineCustomAngle
import Base: +, -
import Base: show
import Base: convert
import Base: *, /
import Base: promote_rule

abstract type Angle end

struct Radian <: Angle
  radians::Float64
end

# Degrees, Minutes, Seconds (DMS)
struct DMS <: Angle
  seconds::Int
end

Minute(minutes::Integer) = DMS(minutes * 60)
Second(seconds::Integer) = DMS(seconds)

Degree(degrees::Integer) = Minute(degrees * 60)
Degree(deg::Integer, min::Integer) = Degree(deg) + Minute(min)

function Degree(deg::Integer, min::Integer, secs::Integer)
  Degree(deg, min) + Second(secs)
end

+(θ::DMS, α::DMS) = DMS(θ.seconds + α.seconds)
-(θ::DMS, α::DMS) = DMS(θ.seconds - α.seconds)

+(θ::Radian, α::Radian) = Radian(θ.radians + α.radians)
-(θ::Radian, α::Radian) = Radian(θ.radians - α.radians)

function degrees(dms::DMS)
  minutes = dms.seconds ÷ 60
  minutes ÷ 60
end

function minutes(dms::DMS)
  minutes = dms.seconds ÷ 60
  minutes % 60
end

seconds(dms::DMS) = dms.seconds % 60

function show(io::IO, dms::DMS)
  print(io, degrees(dms), "° ", minutes(dms), "′ ", seconds(dms), "″")
end

function show(io::IO, rad::Radian)
  print(io, rad.radians, "rad")
end

Radian(dms::DMS) = Radian(deg2rad(dms.seconds / 3600))
Degree(rad::Radian) = DMS(floor(Int, rad2deg(rad.radians) * 3600))

# convert(::Radian, dms::DMS) = Radian(dms)
# convert(::DMS, rad::Radian) = DMS(rad)
# With above, follwoing occurs error. 
# @test DCA.sin(90° + 3.14rad/2) == 0.0007963267107331024
convert(::Type{Radian}, dms::DMS) = Radian(dms)
convert(::Type{DMS}, rad::Radian) = DMS(rad)

sin(rad::Radian) = Base.sin(rad.radians)
cos(rad::Radian) = Base.cos(rad.radians)
sin(dms::DMS) = sin(Radian(dms))
cos(dms::DMS) = cos(Radian(dms))

*(coeff::Number, dms::DMS) = DMS(coeff * dms.seconds)
*(dms::DMS, coeff::Number) = coeff * dms
/(dms::DMS, denom::Number) = DMS(dms.seconds / denom)
*(coeff::Number, rad::Radian) = Radian(coeff * rad.radians)
*(rad::Radian, coeff::Number) = coeff * rad
/(rad::Radian, denom::Number) = Radian(rad.radians / denom)

const ° = Degree(1)
const rad = Radian(1)

+(θ::Angle, α::Angle) = +(promote(θ, α)...)
-(θ::Angle, α::Angle) = -(promote(θ, α)...)

# promote_rule(::Radian, ::DMS) = Radian
# With above, promote_rule does not work.
promote_rule(::Type{Radian}, ::Type{DMS}) = Radian 

end
