module StatePattern

abstract type AbstractState end

struct ListeningState <: AbstractState end
struct EstablishedState <: AbstractState end
struct ClosedState <: AbstractState end

const LISTENING = ListeningState()
const ESTABLISHED = EstablishedState()
const CLOSED = ClosedState()

struct Connection{T <: AbstractState, S}
  state::T
  conn::S
end

# Use multiple dispatch
send(c::Connection, msg) = send(c.state, c.conn, msg)

# Implement `send` method for each state
send(::ListeningState, conn, msg) = error("No connection yet")
send(::EstablishedState, conn, msg) = write(conn, msg * "\n")
send(::ClosedState, conn, msg) = error("Connection already closed")

function test(state, msg)
  c = Connection(state, stdout)
  try
    send(c, msg)
  catch ex
    println("$(ex) for message '$(msg)'")
  end
  return nothing
end

function test()
  test(LISTENING, "hello world 1")
  test(CLOSED, "hello world 2")
  test(ESTABLISHED, "hello world 3")
end

end
