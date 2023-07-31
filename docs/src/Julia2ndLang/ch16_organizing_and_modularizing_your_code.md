# Organizing and modularizing your code

## Module naming rule

From Ref 1.

> Also, it is common to use `UpperCamelCase` for module names
> (just like types), and use the plural form if applicable,
> especially if the module contains a similarly named identifier,
> to avoid name clashes.

## No private method

From Ref 1.

> However, since qualified names always make identifiers accessible, this is just an option for organizing APIs: unlike other languages, Julia has no facilities for truly hiding module internals.

## import modules

From Ref 1.

```julia
import .NiceStuff
```

> This brings *only* the module name into scope. Users would need to use `NiceStuff.DOG`, `NiceStuff.Dog`, and `NiceStuff.nice` to access its contents. Usually, `import ModuleName` is used in contexts when the user wants to keep the namespace clean. As we will see in the next section `import .NiceStuff` is equivalent to `using .NiceStuff: NiceStuff`.

## Test specific dependencies

From [Pkg manual](https://pkgdocs.julialang.org/v1/creating-packages/index.html#Test-specific-dependencies)
we do not need to define separate test project to manage specific test dependencies. This still not well defined as the manual said.

That is, just install package in the project and move the dependency to test as following.

```julia
(HelloWorld) pkg> add Markdown
```

Edit `project.toml` file from

```julia
[deps]
Markdown = "...."

[extra]
Test = "...."

[targets]
test = ["Test"]
```

to

```julia
[deps]

[extra]
Test = "...."
Markdown = "...."

[targets]
test = ["Test", "Markdown"]
```

---

### Module, package and environment

|    Julia    |    Java     |         C++          |       Python        |
| :---------: | :---------: | :------------------: | :-----------------: |
|   Module    |   Package   |      Namespace       |       Module        |
|   Package   |     JAR     |         DLL          |       Package       |
| Environment | Environment | Sandbox or Container | Virtual environment |

Julia module is the same concept as C++ namespace and
environment in Julia has same meaning in virtual environment in Python.

## Using and import

| Ref | Statement                   | What is brought into the scope                                      |
| :-: | :-------------------------- | :------------------------------------------------------------------ |
|  1  | using Calculator            | interest <br/> rate <br/> Calculator.interest <br/> Calculator.rate |
|  2  | using Calculator: interest  | interest                                                            |
|  3  | import Calculator           | Calculator.interest <br/> Calculator.rate                           |
|  4  | import Calculator: interest | Calculator.interest                                                 |
|  4  | import Calculator.interest  | Calculator.interest                                                 |

## Environment stack

See Ref 2, 3 for more detail

```julia
julia> LOAD_PATH
3-element Vector{String}:
"@"
"@v#.#"
"@stdlib"
```

where `@` is the current environment, `@v#.#` is the default environment for the Julia version that is being in use, and `@stdlib` is the standard library.

For instance, for including just the current environment we can set the value of this variable as:

```shell
$ export JULIA_LOAD_PATH="@"
```

Then, when we start a Julia session the default option will be the current environment:

```julia
julia> LOAD_PATH
1-element Vector{String}:
"@"
```

One can also modify the LOAD_PATH directly on the julian prompt with the following functions:

```
julia> empty!(LOAD_PATH)        # this will clean out the path
julia> push!(LOAD_PATH, "@")    # it will add the current environment
```

# References

1. [Julia manual: modules](https://docs.julialang.org/en/v1/manual/modules/)
2. [Environment stacks](https://uppmax.github.io/R-python-julia-HPC/julia/isolatedJulia.html) ([youtube](https://www.youtube.com/watch?v=lMrqOFrKRns))
3. [JuliaCon 2019 | Pkg, Project.toml, Manifest.toml and Environments | Fredrik Ekre](https://www.youtube.com/watch?v=q-LV4zoxc-E)
