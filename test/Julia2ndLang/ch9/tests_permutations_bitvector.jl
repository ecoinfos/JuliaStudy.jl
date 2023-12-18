using Test
using Random
using Permutations

# This code is not related to the book.

@testset "Permutations" begin
  a = [4, 1, 3, 2, 6, 5]
  p = Permutation(a)

  @test length(p) == 6
  p.data
  two_row(p)

  cycles(p)

  p1 = RandomPermutation(12)
  c = cycles(p1)
  Permutation(c)

  q = Permutation([1, 6, 2, 3, 4, 5])
  p * q
  q * p
  p_inv = inv(p)
  p * p_inv
end

@testset "BitVector" begin
  A = BitVector([1, 0, 1, 0, 1, 1, 0, 0])
  sizeof(A)
  @test Base.summarysize(A) == 72
  Aint = Int32[1, 0, 1, 0, 1, 1, 0, 0]
  Base.summarysize(Aint) 
  Abool = Bool[1, 0, 1, 0, 1, 1, 0, 0]
  Base.summarysize(Abool) 

  A << 1
  sum(A)
  @test count_ones(7) == 3

  A[2]
  B = BitArray(undef, 10)
  C = BitArray(undef, 10)
  D = B .& C
  D = B .| C
  D = .! C
  F = BitArray(undef, 2, 10)
  F[:, 1]
  F[:, 2]
  F[1, :] .⊻ F[2, :]

  Bm = bitrand(4, 100)
  Bm[:, 1] .⊻ Bm[:, 5]

  res_bits = BitArray(undef, 6400, 64)
end
