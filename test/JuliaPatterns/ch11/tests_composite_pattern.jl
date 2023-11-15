using Test
import JuliaStudy.JuliaPatterns.CompositePattern as ComP

@testset "Composite Pattern" begin
  sample_folio = ComP.sample_portfolio()
  @test ComP.market_value(sample_folio) == 607347.0
end
