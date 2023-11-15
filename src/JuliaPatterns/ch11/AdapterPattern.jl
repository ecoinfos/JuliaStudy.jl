module AdapterPattern

module LinkedList

export Node, list, prev, next, value

mutable struct Node{T}
  prev::Union{Node, Nothing}
  next::Union{Node, Nothing}
  value::T
end

list(x) = Node(nothing, nothing, x)
prev(n::Node) = n.prev
next(n::Node) = n.next
value(n::Node) = n.value

"Insert new elements at current position."
function Base.insert!(current::Node{T}, x::T) where {T}
  new_node = Node(current, current.next, x)
  if current.next !== nothing
    current.next.prev = new_node
  end
  current.next = new_node
  return current
end

function Base.show(io::IO, n::Node)
  print(io, "Node: $(n.value)")
  n.next !== nothing && (println(), show(n.next))
end

end

using .LinkedList

struct MyArray{T} <: AbstractArray{T, 1}
  data::Node{T}
end

function Base.size(ar::MyArray)
  n = ar.data
  count = 0
  while next(n) !== nothing
    n = next(n)
    count += 1
  end
  return (1 + count, 1)
end

function Base.getindex(ar::MyArray, idx::Int)
  n = ar.data
  for _ in 1:(idx - 1)
    next_node = next(n)
    next_node === nothing && throw(BoundsError(n, idx))
    n = next_node
  end
  return value(n)
end

end
