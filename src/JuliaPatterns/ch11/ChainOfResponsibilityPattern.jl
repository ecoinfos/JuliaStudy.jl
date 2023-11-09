module ChainOfResponsibilityPattern

mutable struct DepositRequest
  id::Int
  amount::Float64
end

@enum Status CONTINUE HANDLED

function update_account_handler(req::DepositRequest)
  println("Deposited $(req.amount) to account $(req.id)")
  return CONTINUE
end

function send_gift_handler(req::DepositRequest)
  req.amount > 100_000 &&
    println("=> Thank you for your business")
  return CONTINUE
end

function notify_customer(::DepositRequest)
  println("Deposit is finished")
  return HANDLED
end

handlers = [update_account_handler, send_gift_handler, notify_customer]

function apply(req::DepositRequest, handlers::AbstractVector{Function})
  for f in handlers
    status = f(req)
    status == HANDLED && return nothing
  end
end

function test()
  println("Test: customer depositing a lot of money")
  amount = 300_000
  apply(DepositRequest(1, amount), handlers)
  println("\nTest: regular customer")
  amount = 1_000
  apply(DepositRequest(2, amount), handlers)
end

end
