module RetryingOperations

using Dates

function do_something(name::AbstractString)
  println(now(), " Let's do it")
  if rand() > 0.5
    println(now(), " Good job, $(name)!")
  else
    error(now(), " Too bad :-(")
  end
end

function do_something_more_robustly(name::AbstractString;
  max_retry_count = 3,
  retry_interval = 2)
  retry_count = 0
  while true
    try
      return do_something(name)
    catch ex
      sleep(retry_interval)
      retry_count += 1
      retry_count > max_retry_count && rethrow(ex)
    end
  end
end

end
