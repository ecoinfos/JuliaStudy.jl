module WorkingWithText

function print_pizzatable(pizzas)
  print("| ")
  printstyled(rpad("name", 12), color = :cyan)
  print(" | ")
  printstyled("size", color = :cyan)
  print(" | ")
  printstyled(rpad("price", 5), color = :cyan)
  print(" |")

  for pz in pizzas
    print("| ", rpad(name(pz), 12))
    print(" | ", rpad(portion(pz), 4), " | ")
    println(lpad(price(pz), 5), " |")
  end
end

name(pizza) = pizza[1]
portion(pizza) = pizza[2]
price(pizza) = pizza[3]

function simple_pizzatable(pizzas)
  pname = rpad("name", 12)
  psize = rpad("size", 4)
  pprice = rpad("price", 5)

  printstyled(pname, " ", psize, " ", pprice, color = :cyan)
  println()

  for pz in pizzas
    pname = rpad(name(pz), 12)
    psize = rpad(portion(pz), 4)
    pprice = lpad(price(pz), 5)
    println(pname, " ", psize, " ", pprice)
  end
end

n = length("-0.966")

function format(x)
  x = round(x, digits = 3)
  if x < 0
    rpad(x, n, '0')
  else
    rpad(x, n - 1, '0')
  end
end

function print_trigtable(inc, maxangle)
  print("│ ")
  printstyled("  θ", color = :cyan)
  print(" │ ")
  printstyled(rpad(" cos", n), color = :cyan)
  print(" │ ")
  printstyled(rpad(" sin", n), color = :cyan)
  println(" │")
  angle = 0
  while angle <= maxangle
    rad = deg2rad(angle)
    cosx = format(cos(rad))
    sinx = format(sin(rad))
    print("│ ")
    print(lpad(angle, 3), " │ ",
      lpad(cosx, 6), " │ ",
      lpad(sinx, 6))
    println(" │")
    angle += inc
  end
end

function store_pizzatable(io, pizzas)
  println(io, "name,size,price")

  for pz in pizzas
    println(io, name(pz), ",", portion(pz), ",", price(pz))
  end
end

function load_pizzatable(io)
  pizzas = []
  readline(io)
  while !eof(io)
    pz = split(readline(io), ',')
    pr = parse(Float64, price(pz))
    sz = portion(pz)
    push!(pizzas, (name(pz)), sz[1], pr)
  end
  pizzas
end

function practice(n)
  correct = 0
  for _ in 1:n
    x = rand(2:9)
    y = rand(2:9)
    print(x, " * ", y, " = ")
    answer = readline(stdin)
    z = parse(Int, answer)
    if z == x * y
      correct += 1
    else
      printstyled("Wrong, it is ", x * y, color = :red)
      println()
    end
  end
  println("Correct: ", correct, " of ", n)
end

end
