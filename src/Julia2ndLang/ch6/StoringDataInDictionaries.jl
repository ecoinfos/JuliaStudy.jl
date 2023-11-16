module StoringDataInDictionaries

roman_numerals = Dict('I' => 1,
  'X' => 10,
  'C' => 100,
  'V' => 5,
  'L' => 50,
  'D' => 500,
  'M' => 1000)

function parse_roman(s)
  s = s |> uppercase |> reverse
  vals = [roman_numerals[ch] for ch in s]
  result = 0
  for (i, val) in enumerate(vals)
    if i > 1 && val < vals[i - 1]
      result -= val
    else
      result += val
    end
  end
  result
end

function lookup(key, table)
  for (k, v) in table
    if key == k
      return v
    end
  end
  throw(KeyError(key))
end

numerals = ['I' => 1,
  'X' => 10,
  'C' => 100,
  'V' => 5,
  'L' => 50,
  'D' => 500,
  'M' => 1000]

keys = ['C', 'D', 'I', 'L', 'M', 'V', 'X']
vals = [100, 500, 1, 50, 1000, 5, 10]

roman_numerals2 = (I = 1, X = 10, C = 100, V = 5, L = 50, D = 500, M = 1000)

function parse_roman2(s)
  s = s |> uppercase |> reverse
  vals = [roman_numerals2[Symbol(ch)] for ch in s]
  result = 0
  for (i, val) in enumerate(vals)
    if i > 1 && val < vals[i - 1]
      result -= val
    else
      result += val
    end
  end
  result
end
end
