module SingletonTypeDispatchPattern

struct OpenCommand end

function process_command(::Val{:open}, filename)
  println("opening file $filename")
end

function process_command(::Val{:close}, filename)
  println("closing file $filename")
end

function process_command(command::String, args...)
  process_command(Val(Symbol(command)), args...)
end

# A parametric type that represents a specific command
struct Command{T} end

# Constructor function to create a new Command instance from a string
Command(s::AbstractString) = Command{Symbol(s)}()

# Dispatcher function
function process_command2(command::String, args...)
  process_command2(Command(command), args...)
end

# Action
function process_command2(::Command{:open}, filename)
  println("opening file $filename")
end

function process_command2(::Command{:close}, filename)
  println("closing file $filename")
end

end
