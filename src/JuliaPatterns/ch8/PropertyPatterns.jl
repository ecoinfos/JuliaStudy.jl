module PropertyPatterns

mutable struct FileContent
  path::Any
  loaded::Any
  contents::Any
end

function FileContent(path)
  ss = lstat(path)
  return FileContent(path, false, zeros(UInt8, ss.size))
end

function load_contents!(fc::FileContent)
  open(fc.path) do io
    readbytes!(io, fc.contents)
    fc.loaded = true
  end
  nothing
end

mutable struct FileContent2
  path::Any
  loaded::Any
  contents::Any
end

function FileContent2(path)
  ss = lstat(path)
  return FileContent2(path, false, zeros(UInt8, ss.size))
end

function Base.getproperty(fc::FileContent2, s::Symbol)
  direct_passthrough_fields = (:path,)
  if s in direct_passthrough_fields
    return getfield(fc, s)
  end
  if s == :contents
    !getfield(fc, :loaded) && load_contents2!(fc)
    return getfield(fc, :contents)
  end
  error("Unsupported property: $s")
end

# lazy load
function load_contents2!(fc::FileContent2)
  open(getfield(fc, :path)) do io
    readbytes!(io, getfield(fc, :contents))
    setfield!(fc, :loaded, true)
  end
  nothing
end

function Base.setproperty!(fc::FileContent2, s::Symbol, value)
  if s == :path
    ss = lstat(value)
    setfield!(fc, :path, value)
    setfield!(fc, :loaded, false)
    setfield!(fc, :contents, zeros(UInt8, ss.size))
    println("Object re-initialized for $value (size $(ss.size))")
    return nothing
  end
  error("Property $s cannot be changed.")
end

function Base.propertynames(::FileContent2)
  return (:path, :contents)
end

end
