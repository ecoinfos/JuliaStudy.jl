using Test

@testset "Flyweight Pattern" begin
  s = ["Male" for _ in 1:1_000]
  @test Base.summarysize(s) == 8052

  s100 = ["Male" for _ in 1:100_000]
  @test Base.summarysize(s100) == 800052

  sn = [0x01 for _ in 1:100_000]
  @test Base.summarysize(sn) == 100040

  sb = BitArray(rand(Bool) for _ in 1:100_000)
  @test Base.summarysize(sb) == 12568

  gender_map = Dict(true => "Male", false => "Female") 
  @test Base.summarysize(gender_map) == 370
end
