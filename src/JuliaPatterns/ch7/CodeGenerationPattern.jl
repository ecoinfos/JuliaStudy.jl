module CodeGenerationPattern

export Logger, INFO, WARNING, ERROR, info_ori!
export info!, warning!, error!
export info2!, warning2!, error2!
export info3!, warning3!, error3!

const INFO = 1
const WARNING = 2
const ERROR = 3

struct Logger
  filename::Any   # log file name
  level::Any      # minumum level acceptable to be logged
  handle::Any     # file handle
end

Logger(filename, level) = Logger(filename, level, open(filename, "w"))

using Dates

function info_ori!(logger::Logger, args...)
  if logger.level <= INFO
    let io = logger.handle
      print(io, trunc(now(), Dates.Second), " [INFO] ")
      for (idx, arg) in enumerate(args)
        idx > 0 && print(io, " ")
        print(io, arg)
      end
      println(io)
      flush(io)
    end
  end
end

for level in (:info, :warning, :error)
  lower_level_str = String(level)
  upper_level_str = uppercase(lower_level_str)
  upper_level_sym = Symbol(upper_level_str)

  fn = Symbol(lower_level_str * "!")
  label = " [" * upper_level_str * "] "

  @eval function $fn(logger::Logger, args...)
    if logger.level <= $upper_level_sym
      let io = logger.handle
        print(io, trunc(now(), Dates.Second), $label)
        for (idx, arg) in enumerate(args)
          idx > 0 && print(io, " ")
          print(io, arg)
        end
        println(io)
        flush(io)
      end
    end
  end
end

function logme!(level, label, logger::Logger, args...)
  if logger.level <= level
    let io = logger.handle
      print(io, trunc(now(), Dates.Second), label)
      for (idx, arg) in enumerate(args)
        idx > 0 && print(io, " ")
        print(io, arg)
      end
      println(io)
      flush(io)
    end
  end
end

info2!(logger::Logger, msg...) = logme!(INFO, " [INFO] ", logger, msg...)
function warning2!(logger::Logger, msg...)
  logme!(WARNING, " [WARNING] ", logger, msg...)
end
error2!(logger::Logger, msg...) = logme!(ERROR, " [ERROR] ", logger, msg...)

function make_log_func(level, label)
  (logger::Logger, args...) -> begin
    if logger.level <= level
      let io = logger.handle
        print(io, trunc(now(), Dates.Second), " [", label, "] ")
        for (idx, arg) in enumerate(args)
          idx > 0 && print(io, " ")
          print(io, arg)
        end
        println(io)
        flush(io)
      end
    end
  end
end

info3! = make_log_func(INFO, "INFO")
warning3! = make_log_func(WARNING, "WARNING")
error3! = make_log_func(ERROR, "ERROR")

end
