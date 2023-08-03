export findroot

function findroot(T::Type)::String
  path = string(T)
  if T != supertype(T)
    path *= " -> " * findroot(supertype(T))
  end
  path
end
