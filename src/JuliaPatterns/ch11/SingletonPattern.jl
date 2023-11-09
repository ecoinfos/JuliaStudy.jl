module SingletonPattern

# AppKey contains an app id and encryption key
struct AppKey
  appid::String
  value::UInt128
end

# placeholder for AppKey object.
const appkey = Ref{AppKey}()

function construct()
  global appkey
  if !isassigned(appkey)
    ak = AppKey("myapp", rand(UInt128))
    println("constructing $ak")
    appkey[] = ak
  end
  return nothing
end

function test_multithreading()
  println("Number of threads: ", Threads.nthreads())
  global appkey
  Threads.@threads for _ in 1:8
    construct()
  end
end

const appkey_lock = Ref(ReentrantLock())

# change construct() function to acquire lock before
# construction, and release it after it's done.
function construct2()
  global appkey
  global appkey_lock
  lock(appkey_lock[])
  try
    if !isassigned(appkey)
      ak = AppKey("myapp", rand(UInt128))
      println("constructing $ak")
      appkey[] = ak
    else
      println("skipped construction")
    end
  finally
    unlock(appkey_lock[])
    return appkey[]
  end
end

function test_multithreading2()
  println("Number of threads: ", Threads.nthreads())
  global appkey
  Threads.@threads for _ in 1:8
    construct2()
  end
end

end
