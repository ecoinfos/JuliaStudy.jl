using Test
import JuliaStudy.JuliaPatterns.SingletonTypeDispatchPattern as ST
import JuliaStudy.JuliaPatterns.CreditApproval as CA
import JuliaStudy.JuliaPatterns.CreditApprovalStub as CS
import JuliaStudy.JuliaPatterns.CreditApprovalMockingStub as CM
using BenchmarkTools
using Mocking

@testset "Singleton type" begin
  oc1 = ST.OpenCommand()
  oc2 = ST.OpenCommand()
  @test oc1 === oc2

  Val(1)
  Val(1) |> typeof
  Val(2) |> typeof

  @test Val(1) === Val(1)
  @test Val(:foo) === Val(:foo)
  @test_throws TypeError Val("Julia")

  ST.process_command(Val(:open), "julia.pdf")

  ST.process_command("open", "julia.pdf")
  ST.process_command("close", "julia.pdf")

  ST.process_command2("open", "julia.pdf")
  ST.process_command2("close", "julia.pdf")
end

@testset "Performance benefits of dispatch" begin
  ntuple(i -> 2i, 10)
  # @edit ntuple(i -> 2i, 10)
  @btime ntuple(i -> 2i, 10)
  @btime ntuple(i -> 2i, 11)
  @btime ntuple(i -> 2i, 100)

  @btime ntuple(i -> 2i, Val(10))
  @btime ntuple(i -> 2i, Val(11))
  @btime ntuple(i -> 2i, Val(100))
end

@testset "CreditApprovalStub.jl" begin

  # Stubs
  check_background_success(first_name, last_name) = true
  check_background_failure(first_name, last_name) = false

  # Testing
  let first_name = "John", last_name = "Doe",
    email = "jdoe@julia-is-awesome.com"

    @test CS.open_account(first_name,
      last_name,
      email,
      checker = check_background_success) == :success
    @test CS.open_account(first_name,
      last_name,
      email,
      checker = check_background_failure) == :failure
  end
end

@testset "CreditApprovalMockingStub.jl" begin
  Mocking.activate()

  check_background_success_patch = @patch function CM.check_background(first_name,
    last_name)
    println("check_background stub ==> simulating success")
    return true
  end

  check_background_failure_patch = @patch function CM.check_background(first_name,
    last_name)
    println("check_background stub ==> simulating failure")
    return false
  end

  # test background check failure case
  apply(check_background_failure_patch) do
    @test CM.open_account("John", "Doe", "jdoe@julia-is-awesome.com") ==
          :failure
  end

  # test background check success case
  apply(check_background_success_patch) do
    @test CM.open_account("John", "Doe", "jdoe@julia-is-awesome.com") ==
          :success
  end

  CM.open_account("John", "Doe", "jdoe@julia-is-awesome.com")

  create_account_patch = @patch function CM.create_account(first_name,
    laast_name,
    email)
    println("create_account stub is called")
    return 314
  end

  apply([check_background_success_patch, create_account_patch]) do
    @test CM.open_account("John", "Doe", "pdoe@julia-is-awesome.com") ==
          :success
  end
end

@testset "Performing behavior verification using mocks" begin
  let check_background_call_count = 0,
    create_account_call_count = 0,
    notify_downstream_call_count = 0,
    notify_downstream_received_proper_account_number = false

    check_background_success_patch = @patch function CM.check_background(first_name,
      last_name)
      check_background_call_count += 1
      println("check_background mock is called, simulating success")
      return true
    end

    create_account_patch = @patch function CM.create_account(first_name,
      last_name,
      email)
      create_account_call_count += 1
      println("create account_number mock is called")
      return 314
    end

    notify_downstream_patch = @patch function CM.notify_downstream(account_number)
      notify_downstream_call_count += 1
      if account_number > 0
        notify_downstream_received_proper_account_number = true
      end
      println("notify downstream mock is called")
      return nothing
    end

    function verify()
      @test check_background_call_count == 1
      @test create_account_call_count == 1
      @test notify_downstream_call_count == 1
      @test notify_downstream_received_proper_account_number
    end

    apply([check_background_success_patch,
      create_account_patch,
      notify_downstream_patch]) do
      @test CM.open_account("John", "Doe", "pdoe@julia-is-awesome.com") ==
            :success
    end
    verify()
  end
end
