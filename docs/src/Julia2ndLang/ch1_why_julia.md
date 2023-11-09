# Why Julia?

## What is Julia?

The reason to use Julia can be found in the
[Julia blog: Why we create Julia](https://julialang.org/blog/2012/02/why-we-created-julia/).

> We are greedy: we want more.
> We want a language that's open source, with a liberal license.
> We want the speed of C with the dynamism of Ruby.
> We want a language that's [**homoiconic**](https://en.wikipedia.org/wiki/Homoiconicity), with true macros like Lisp,
> but with obvious, familiar mathematical notation like Matlab.
> We want something as usable for general programming as Python,
> as easy for statistics as R, as natural for string processing as Perl,
> as powerful for linear algebra as Matlab, as good at gluing programs together as the shell.
> Something that is dirt simple to learn, yet keeps the most serious hackers happy.
> We want it interactive and we want it compiled.

From Ref 1.

> Julia is a general-purpose, multi-platform programming Language that is
> Suited for numerical analysis and computational Science
> Dynamically typed (In static language, expression have types; in dynamic language, values have types. -Stefan karpinski)
> High performance and just-in-time compiled
> Using automatic memory management (garbage collection)
> Composable

## Pros & Cons of Julia

Mainly cited from Ref 1.

> Julia is a relatively new programming language that overcomes the two-language problem (Ref 2.)

- It provides both "easy-to-use" and "high performance" advantages.
- Growing ecosystem of state-of-the-art application packages allow scientists to expand their research interests.
  > Julia is a dynamically typed but is as fast as statically typed languages through JIT compilation.
- This is TRUE in recent scientific research, in which large amount data is available.
  > Julia catches two rabbits! -> Satisfy scientists and other developers who require the fascinating features of both dynamically & statically typed languages.

add an image (Ref 3.)

```julia
filter(!isempty, readlines(filename))  # strip out empty lines
filter(endswith("*.png"), readdir())   # get PNG files
findall(==(4), [4, 8, 4, 2, 5, 1])     # find every index of the number 4
```

## Julia's powerful features

From Ref 1.

> Strong facilities for modularizing and reusing code.
> A strict type system that helps catch bugs in your code when it runs.
> A sophisticated system for reducing repetitive boilerplate code (metaprogramming9).
> A rich and flexible type system that allows you to model a wide variety of problems.
> A well-equipped standard library and various third-party libraries to handle various tasks.
> Great string processing facilities. This ability is usually a key selling point for any Swiss-Army-knife-style programming language. It is what initially made languages such as Perl, Python, and Ruby popular.
> Easy interfacing with a variety of other programming languages and tools.

Examples of Julia applications in various resaerch fields

|        Science        |      Non-science       |
| :-------------------: | :--------------------: |
| Computational biology | Genie, Blink, GTK, QML |
|      Statistics       | GameZero, Luxor, Gumbo |
|   Machine learning    | Miletus, TerminalMenus |
|   Image processing    |    Cascadia, QRCode    |

# References

1. [Engheim, E., 2023. Julia as a Second Language, Manning, NY, ISBN 978-16-1729971-1.]
2. [Roesch, E., Greener, J. G., MacLean, A. L., Nassar, H., Rackauckas, C., Holy, T. E., Stumpf, M. P. H., 2023. Julia for biologists. Nature Methods, 20: 655-664] (https://doi.org/10.1038/s41592-023-01832-z)
3. [Nazarathy, Y., 2022. Why use Julia for scientific computing?] (https://youtu.be/DGyEekhgdew)
