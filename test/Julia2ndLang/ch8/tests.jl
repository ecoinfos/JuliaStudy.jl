using Test

import JuliaStudy.Julia2ndLang.Rockets as Roks
import JuliaStudy.Julia2ndLang.simulate as sim

@testset "Tank" begin
  small = Roks.SmallTank(50)
  @test Roks.consume!(small, 10) == 40.0
  @test Roks.consume!(small, 10) == 30.0
  small
  Roks.refill!(small)

  flexi = Roks.FlexiTank(5, 50, 0)
  Roks.refill!(flexi)

  tank = Roks.FlexiTank(5, 50, 10)
  @test_throws DomainError Roks.propellant!(tank, 100)
  @test Roks.totalmass(tank) == 50.0
  @test Roks.mass(tank) == 15.0

  t = Roks.FlexiTank(5, 50, 90)
  @test (Roks.mass(t), Roks.totalmass(t)) == (95.0, 50.0)

  @test length(methods(Roks.FlexiTank)) == 3

  Roks.FlexiTank(5, 50)
  Roks.MediumTank()
  Roks.LargeTank()

  t = Roks.FlexiTank2(5, 50)
  @test_throws MethodError t2=Roks.FlexiTank2(5, 50, 150)
  @test length(methods(Roks.FlexiTank2)) == 1
end

@testset "Engine" begin
  engine_thrust = 845e3
  isp = 282
  thrust = engine_thrust * 9
  flow = Roks.mass_flow(thrust, isp)
end

@testset "Rocket" begin
  payload = Roks.Payload(300)
  tank = Roks.SmallTank()
  engine = Roks.Rutherford()
  rocket = Roks.Rocket(payload, tank, engine)
end

@testset "Rocket with multiple stages" begin
  payload = Roks.Payload2(300)
  thirdstage = Roks.Rocket2(payload, Roks.SmallTank(), Roks.Curie())
  secondstage = Roks.Rocket2(thirdstage, Roks.MediumTank(), Roks.Rutherford())
  booster = Roks.Rocket2(secondstage,
    Roks.LargeTank(),
    Roks.Cluster(Roks.Rutherford(), 9))
end

@testset "Simulation" begin
  engine = Roks.Rutherford()
  tank = Roks.SmallTank()
  payload = Roks.Payload2(300)
  rocket = Roks.Rocket2(payload, tank, engine)
  sim.launch!(rocket, 0.5)
  @test tank.propellant == 0
end
