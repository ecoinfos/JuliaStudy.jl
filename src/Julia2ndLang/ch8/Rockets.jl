module Rockets

include("tanks.jl")
include("engines.jl")

abstract type Rocket2 end

include("payloads.jl")

struct Rocket
  payload::Payload
  tank::Tank
  engine::Engine
end

struct StagedRocket <: Rocket2
  nextstage::Rocket2
  tank::Tank
  engine::Engine
end

function Rocket2(payload::Rocket2, tank::Tank, engine::Engine)
  StagedRocket(payload, tank, engine)
end

thrust(r::Payload2) = 0.0 # no engines
thrust(r::StagedRocket) = thrust(r.engine)

function update!(r::StagedRocket, t::Number, Δt::Number)
  mflow = mass_flow(thrust(r), Isp(r.engine))
  consume!(r.tank, mflow * Δt)
end

# Payload has no tanks with propellant to consume
update!(r::Payload2, t::Number, Δt::Number) = nothing

mass(payload::Payload2) = payload.mass

function mass(r::StagedRocket)
  mass(r.nextstage) + mass(r.tank) + mass(r.engine)
end

end
