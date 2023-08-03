using Test
using JuliaStudy.Julia2ndLang
using JuliaStudy.Julia2ndLang.BattleSimul
using JuliaStudy.JuliaPatterns.DataTypeConcepts
using Random

@testset "Understanding Types" begin
  @test typeof(42) == Int64
  @test typeof('A') == Char
  @test typeof("Hello") == String

  function iferror()
    if 2.5
      print("this should not be possible")
    end
  end
  @test_throws TypeError iferror()

  @test isprimitivetype(Int8)
  @test isprimitivetype(Char)
  @test isprimitivetype(String) == false

  robin = Archer("Robin Hood", 30, 24)
  william = Archer("William Tell", 28, 1)
  @test robin.name == "Robin Hood"
  @test william.name == "William Tell"
  robin_dic = Dict("name" => "Robin Hood", "health" => 30, "arrows" => 24)
  @test robin_dic["name"] == "Robin Hood"
  @test robin_dic["arrows"] == 24

  # print(subtypeTreeStr(Number, 2))
  # Julia 1.0 or nightly will be failed.
  @test subtypes(Number)==Any[Complex, Real] skip=true
  @test subtypes(Real) ==
        Any[AbstractFloat, AbstractIrrational, Integer, Rational]
  @test subtypes(Integer) == Any[Bool, Signed, Unsigned]
  T = typeof(42)
  @test T == Int64
  T = supertype(T)
  @test T == Signed
  T = supertype(T)
  @test T == Integer
  T = supertype(T)
  @test T == Real
  T = supertype(T)
  @test T == Number
  T = supertype(T)
  @test T == Any
  T = supertype(T)
  @test T == Any

  @test findroot(Any) == "Any"
  @test findroot(Number) == "Number -> Any"
  @test findroot(Real) == "Real -> Number -> Any"
  @test findroot(Integer) == "Integer -> Real -> Number -> Any"
  @test findroot(Signed) == "Signed -> Integer -> Real -> Number -> Any"
  @test findroot(Int64) ==
        "Int64 -> Signed -> Integer -> Real -> Number -> Any"
  @test findroot(typeof(42)) ==
        "Int64 -> Signed -> Integer -> Real -> Number -> Any"

  integers = Integer[42, 8]
  @test_throws MethodError integers[2]="Hello"

  @test String <: Any
  @test (String <: Integer) == false
  @test Int8 <: Integer
  @test (Float64 <: Integer) == false
end

@testset "Warrior" begin
  robin = Archer("Robin Hood", 34, 24)
  @test_throws MethodError Warrior()
  @test shoot!(robin) == Archer("Robin Hood", 34, 23)
  @test shoot!(robin) == Archer("Robin Hood", 34, 22)
  @test shoot!(robin) == Archer("Robin Hood", 34, 21)
  @test resupply!(robin) == Archer("Robin Hood", 34, 24)

  @test length(methods(shoot!)) == 1
  @test length(methods(attack!)) == 4
  @test length(methods(mount!)) == 1

  # this is different from `void_shoot!()`
  # When above used, 1 method defined. 
  # check with `methods(void_shoot!)`
  function void_shoot! end
  function void_resupply! end
  function void_attack! end
  robin = Archer("Robin Hood", 34, 24)
  white = Knight("Lancelot", 34, true)
  @test_throws MethodError void_attack!(robin, white)
  @test_throws MethodError void_shoot!(robin)
  @test_throws UndefVarError void_mount!(white)
  @test length(methods(void_shoot!)) == 0
  @test_throws UndefVarError methods(void_mount!)

  robin = Archer("Robin Hood", 34, 24)
  tell = Archer("William Tell", 30, 20)
  white = Knight("Lancelot", 34, true)
  black = Knight("Morien", 35, true)
  Random.seed!(1234)
  @test attack!(robin, white) == (34, 29)
  @test attack!(robin, white) == (34, 22)
  @test attack!(tell, robin) == (30, 26)
  @test attack!(black, white) == (29, 19)

  Random.seed!(1234)
  robin = Archer("Robin Hood", 34, 24)
  white = Knight("Lancelot", 34, true)
  @test battle!(robin, white) == "Lancelot survived attack from Robin Hood"
  @test battle!(robin, white) == "Lancelot survived attack from Robin Hood"
  @test battle!(robin, white) == "Lancelot survived attack from Robin Hood"
  @test battle!(robin, white) == "Lancelot survived attack from Robin Hood"
  @test battle!(robin, white) == "Lancelot survived attack from Robin Hood"
  @test battle!(robin, white) == "Robin Hood defeated Lancelot"
end
