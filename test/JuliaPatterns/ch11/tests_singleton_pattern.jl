using Test
import JuliaStudy.JuliaPatterns.SingletonPattern as SP

@testset "Singleton pattern " begin
  Threads.nthreads()
  Threads.threadpool()

  SP.test_multithreading()

  SP.test_multithreading2()
end
