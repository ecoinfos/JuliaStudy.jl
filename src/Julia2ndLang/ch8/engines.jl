abstract type Engine end

struct CustomEngine <: Engine
  mass::Float64
  thrust::Float64
  Isp::Float64
end

mass(engine::CustomEngine) = engine.mass
thrust(engine::CustomEngine) = engine.thrust
Isp(engine::CustomEngine) = engine.Isp

struct Rutherford <: Engine end
struct Merlin <: Engine end

mass(::Rutherford) = 35.0
thrust(::Rutherford) = 25000.0
Isp(::Rutherford) = 311.0

mass(::Merlin) = 470.0
thrust(::Merlin) = 385e3
Isp(::Merlin) = 282.0

g = 9.80665
function mass_flow(thrust::Number, Isp::Number)
  thrust / (Isp * g)
end

struct Cluster <: Engine
  engine::Engine
  count::Int
end

Isp(cl::Cluster) = Isp(cl.engine)
mass(cl::Cluster) = mass(cl.engine) * cl.count
thrust(cl::Cluster) = thrust(cl.engine) * cl.count

struct Curie <: Engine end

mass(::Curie) = 8.0
thrust(::Curie) = 120.0
Isp(::Curie) = 317.0
