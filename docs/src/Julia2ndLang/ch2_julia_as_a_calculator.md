# Julia as a calculator

## The Julia command line

> Julia REPL behaves almost similar to general scientific or engineering calculators. In most cases, Julia accepts input style which people are familiar to.  

## Using constants and variables

> We can use identifiers, constants, variables, and function in Julia coding as well as Julia REPL
  * const let us define our own constants
  * \ enables display built-in constants with their symblos
  * Julia binds number and variables, does not assign. A variable that has a number can be bound to a new number.
  * Julia supports literal coefficient, by tab completion (see table below).
```julia
x = 3
2 * x = 6
2x = 6
```
|  Character  |  Tab Completion  |
| :---------: | :--------------: |
|   Module    |       \pi        |
|   Package   |      \theta     |
| Environment | \Delta |
|             | \euler |
|             | \sqrt|
|             |\varphi |

## Different number types and their bit length in Julia

> Julia provides various types of numbers
  * Integer: default bit length of Julia is 'signed 64-bit (Int64).'
  * Julia does not automatically pick a number type large enough to hodl the result of an arithmetic operation (overflows).
  * Julia defaults to showing all signed numbers in decimal format and unsigned numbers, such as UInt8, in hexadecimal format.

## Floating-point numbers

  * The default size is 64 bit, which means each floating-point number consumes 8 bytes of memory

## Defining functions

  * Functions use constants and arguments.
  * Functions can be saved in a .jl file.

```julia
r = 4.5
V = 4*pi*r^3/3  # V=381.7035... r is the argument, and V will be recalculated as r changes
foo(x, y, z) = 2x + 4y - z  # x, y, z are arguments that consist of the function foo
```
```julia
# Volume calculations, consider that the code below is saved as 'volumes.jl'
sphere_volume(r)        = 4*pi*r^3/3  # r is argument
cylinder_volume(r, h)   = pi*r^2*h    # r, h are arguments

# In julia REPL
include("volumes.jl")
cylinder_volume(1, 2)
6.2831...
```

## How to use numbers in practice
> Keep in mind the below
  * Just use the default integer and floating-point sizes. Only consider smaller or larger numbers when performance or the nature of your problem demands it.
  * Prefer signed integers to unsigned. It is very easy to make a mistake using unsigned numbers.
