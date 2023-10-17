using Test
import JuliaStudy.JuliaPatterns.PropertyPatterns as PP

@testset "Lazy file loader" begin
  fc = PP.FileContent("/etc/hosts")
  @test fc.loaded == false

  PP.load_contents!(fc)
  @test fc.loaded == true
  fc.contents

  Meta.lower(Main, :(fc.path))
  Meta.lower(Main, :(fc.path = "/etc/hosts"))
  # @edit fc.path
  
  fc2 = PP.FileContent2("/etc/hosts")
  fc2.contents
  fc2.path
  # Error Should occur: fc.loaded
  
  fc2.path = "/etc/profile"
  # fc2.contents = []
  
end

