using Test
import JuliaStudy.Julia2ndLang.DefineCustomAngle as DCA
import JuliaStudy.Julia2ndLang.DefineCustomAngle: °, rad

@testset "Comversion and Promotion" begin
  @test 3 + 4.2 == 7.2
  @test UInt8(5) + Int128(3e6) == 3000005
  @test 1 // 4 + 0.25 == 0.5

  # @edit 2 + 3.5
  +(2, 3.5)
  promote(2, 3.5)
  typeof(1 // 2), typeof(42.5), typeof(false), typeof(0x5)
  values = promote(1 // 2, 42.5, false, 0x5)
  @test map(typeof, values) == (Float64, Float64, Float64, Float64)

  x = Int8(32)
  typeof(x)
  Int8(4.0)
  Float64(1 // 2)
  Float32(24)
  @test_throws InexactError Int8(1000)
  @test_throws InexactError Int64(4.5)
  convert(Int64, 5.0)
  convert(Float64, 5)
  convert(UInt8, 4.0)
  convert(UInt8, 0o7)  # octal
  1 // 4 + 1 // 4
  convert(Float64, 1 // 4 + 1 // 4)
  @test 3 isa Int64
  @test Int64 isa Type{Int64}
  @test "hi" isa String
  @test String isa Type{String}
  @test (Int64 isa Type{String}) == false

  values2 = Int8[3, 5]
  typeof(values2)
  @test Base.summarysize(values2) == 42
  x2 = 42
  typeof(42)
  values2[2] = x2

  mutable struct Point
    x::Float64
    y::Float64
  end
  p = Point(3.5, 6.8)
  p.x = Int8(10)

  foo(x::Int64)::UInt8 = 2x
  y = foo(42)
  @test typeof(y) == UInt8
end

@testset "Displaying DMS angles" begin
  α = DCA.Degree(90, 30, 45)
  @test DCA.degrees(α) == 90
  @test DCA.minutes(α) == 30
  @test DCA.seconds(α) == 45

  β = DCA.Degree(90, 30) + DCA.Degree(90, 30)
  @test DCA.degrees(β) == 181
  @test DCA.minutes(β) == 0

  DCA.Radian(π)

  @test_throws MethodError DCA.sin(π / 2)
  @test_throws MethodError DCA.sin(90)

  @test DCA.sin(DCA.Degree(90)) == 1.0
  @test DCA.sin(DCA.Radian(π / 2)) == 1.0

  @test DCA.sin(90°) == 1.0
  @test DCA.sin(1.5rad) == 0.9974949866040544
  # @test DCA.sin(1.5 rad) == 0.9974949866040544
  @test DCA.cos(30°) == 0.8660254037844387
  @test DCA.cos(90° / 3) == 0.8660254037844387
  @test DCA.sin(3rad / 2) == 0.9974949866040544

  @test promote_rule(Int16, UInt8) == Int16
  @test promote_rule(Float64, UInt8) == Float64
  @test promote_rule(DCA.Radian, DCA.DMS) == DCA.Radian

  @test DCA.sin(90° + 3.14rad / 2) == 0.0007963267107331024
  @test DCA.cos(90° + 3.14rad / 2) == -0.9999996829318346
  @test 45° + 45° == 90°
  @test DCA.Radian(45° + 45°) == 1.5707963267948966rad
  @test 45° + 3.14rad / 4 == 1.5703981633974484rad
end
