module simulate

using JuliaStudy.Julia2ndLang.Rockets: mass, Rocket2, thrust, update!

function launch!(rocket::Rocket2, Δt::Real)
  g = 9.80665  # acceleration caused by gravity
  v = 0.0      # velocity
  h = 0.0      # altitude (height)

  for t in 0:Δt:1000
    m = mass(rocket)
    F = thrust(rocket) - m * g

    remaining = update!(rocket, t, Δt)

    # Any propellant and thrust left?
    if remaining == 0 || F <= 0
      return (t, h)
    end

    h += v * Δt
    a = F / m
    v += a * Δt
  end
end

end
