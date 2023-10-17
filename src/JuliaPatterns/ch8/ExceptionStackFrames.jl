module ExceptionStackFrames

function foo1()
  foo2()
end

function foo2()
  foo3()
end

function foo3()
  throw(ErrorException("bad things happend"))
end

function pretty_print_staktrace(trace)
  for (i, v) in enumerate(trace)
    println(i, " => ", v)
  end
end

function foo1_1()
  try
    foo2()
  catch
    println("handling error gracefully")
    pretty_print_staktrace(stacktrace())
  end
end

function foo1_2()
  try
    foo2()
  catch
    println("handling error gracefully")
    pretty_print_staktrace(stacktrace(catch_backtrace()))
  end
end
end
