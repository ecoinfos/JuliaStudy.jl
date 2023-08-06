using Test
using JuliaStudy.JuliaPatterns.SpaceWar
using JuliaStudy.JuliaPatterns.Vehicle
using JuliaStudy.JuliaPatterns.FighterJets

module Ch3Foo
foo(x, y) = 1
foo(x::Integer, y) = 2
foo(x, y::Integer) = 3
end

module Ch3Foo2
foo(x, y) = 1
foo(x::Integer, y) = 2
foo(x, y::Integer) = 3
foo(x::Integer, y::Integer) = 4
end

module Ch3Foo3
import Main.Ch3Foo
foo(x::Integer, y::Integer) = 4
end

@testset "Space War" begin
  @test_throws MethodError move_up!(1, 2)

  w = Widget("asteroid", Position(0, 0), Size(10, 20))
  @test move_up!(w, 10) == -10
  @test move_down!(w, 10) == 0
  @test move_left!(w, 20) == -20
  @test move_right!(w, 20) == 0

  asteroids = make_asteroids(5)
  asteroids = make_asteroids(5, 1:10)
  @test length(methods(make_asteroids)) == 3
  asteroids = make_asteroids(5, 100:5:200, 200:10:500)

  asteroids = make_asteroids2(5, pos_range = 100:5:200)
  asteroids = make_asteroids2(5, size_range = 1:5, pos_range = 0:10:100)

  asteroids = make_asteroids3(N = 3)
  spaceship = Widget("Spaceship", Position(0, 0), Size(30, 30))
  target1 = asteroids[1]
  target2 = asteroids[2]
  target3 = asteroids[3]
  shoot(spaceship, target1)

  spaceships = [Widget("Spaceship $i", Position(0, 0), Size(20, 50))
                for i in 1:3]
  triangular_formation!(spaceships...)
  spaceships

  spaceship = Widget("Spaceship", Position(0, 0), Size(20, 50))
  random_leap!(spaceship, random_move(), rand(50:100))
  random_leap!(spaceship, random_move(), rand(50:100))
  random_leap!(spaceship, random_move(), rand(50:100))

  fire(s -> println(s, " launched missile!"), spaceship)
  fire(s -> println(s, " launched missile!"), spaceship)

  fire(spaceship) do s
    move_up!(s, 100)
    println(s, " launched missile!")
    move_down!(s, 100)
  end

  process_file("/etc/hosts") do ios
    lines = readlines(ios)
    println(length(lines))
  end

  process_file("/etc/passwd") do ios
    lines = readlines(ios)
    println(length(lines))
  end

  s1 = Spaceship(Position(0, 0), Size(30, 5), Missile)
  s2 = Spaceship(Position(10, 0), Size(30, 5), Laser)
  a1 = Asteroid(Position(20, 0), Size(20, 20))
  a2 = Asteroid(Position(0, 20), Size(20, 20))
  SpaceWar.position(s1), SpaceWar.size(s1), SpaceWar.shape(s1)
  SpaceWar.position(a1), SpaceWar.size(a1), SpaceWar.shape(a1)

  @test collide(s1, s2)
  @test collide(a1, a2)
  @test collide(s1, a1) == false
  @test collide(a1, s1)

  @test collide(a1, s1)
  @test collide(s1, a1) == false

  @test collide(a1, a2)

  @test length(detect_ambiguities(Ch3Foo)) == 1

  @test length(detect_ambiguities(Ch3Foo2)) == 0

  @test length(detect_ambiguities(Ch3Foo3)) == 0

  check_randomly([s1, s2, a1, a2])
end

@testset "Leveraging parametric methods" begin
  s1 = Spaceship(Position(0, 0), Size(30, 5), Missile)
  s2 = Spaceship(Position(10, 0), Size(30, 5), Laser)
  a1 = Asteroid(Position(20, 0), Size(20, 20))
  a2 = Asteroid(Position(0, 20), Size(20, 20))

  explode([a1, a2])
  explode([:building, :hill])
  @test Vector{Asteroid} <: AbstractVector{Asteroid}

  methods(tow)
  group_anything(s1, s2)
  group_anything(a1, a2)
  group_anything(s1, a1)
  group_anything(a1, s1)

  group_same_things(s1, s2)
  group_same_things(a1, a2)
  @test_throws MethodError group_same_things(s1, a1)
  @test_throws MethodError group_same_things(a1, s1)

  @test SpaceWar.eltype([s1, s2]) == Spaceship
  @test SpaceWar.eltype([a1, a2]) == Asteroid
  @test SpaceWar.eltype([s1, s2, a1, a2]) == SpaceWar.Thing
  @test typeof([s1, s2]) == Vector{Spaceship}
  @test typeof([a1, a2]) == Vector{Asteroid}
  @test typeof([s1, s2, a1, a2]) == Vector{SpaceWar.Thing}
end

@testset "Working with interface" begin
  fj = FighterJet(false, 0, (0, 0))
  go!(fj, :mars)

end
