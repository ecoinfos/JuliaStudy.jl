# Setup Julia Repo in GitHub with Actions

## Install Julia

Basically if you are using Linux or Mac, you can easily install Julia by the package manager.
For Gentoo, we can install it with portage as following.

```shell
$ sudo emerge -av julia

```

The problem to install Julia by [Gentoo package manager](https://wiki.gentoo.org/wiki/Portage)
is slow upgrade speed.
In this time, July 27 2023, latest stable version version of Julia in the
[official site](https://julialang.org/downloads/) is 1.9.2 but Gentoo still has
1.8.5 as the latest one.
To overcome this gap, according to the instruction in [Julia GitHub](https://github.com/JuliaLang/julia)
we can easily install it by compiling source.

```shell
$ cd localgit  <-- local git directory
$ git clone https://github.com/JuliaLang/julia.git
$ cd julia
$ git checkout v1.9.2  <-- tag for latest version
$ make
$ ln -s julia ~/.local/bin/julia  <-- This should be earlier path than /usr/bin/julia
```

## Setup Julia language server with formatter for Neovim

!!! info

    This setup is based on cloned
    [Neovim-from-scratch](https://github.com/erdosxx/Neovim-from-scratch/tree/27_Julia_REPL)
    and [Github repo: evoagile_configs](https://github.com/erdosxx/evoagile_configs) repo.

To setup LSP([Language Server Protocol](https://microsoft.github.io/language-server-protocol/)) with
[julials.lua](https://github.com/erdosxx/Neovim-from-scratch/blob/27_Julia_REPL/lua/user/lsp/settings/julials.lua)
file in [Neovim-from-scratch](https://github.com/erdosxx/Neovim-from-scratch/tree/27_Julia_REPL),
we need to setup `nvim-lspconfig` environment first.
Using [stow](https://packages.gentoo.org/packages/app-admin/stow) tool,
we can copy `Makefile` to `~/.julia/environments/nvim-lspconfig/`.

```shell
$ cd localgit/evoagile_configs   <-- if your local cloned repo is in localgit
$ stow -t ~ julia
$ cd ~/.julia/environments/nvim-lspconfig/
$ make
```

After `make` command, `neovim` is launched and open `Example.jl` source file with
some errors. If you wait a moment and no problem occur to install, you can find
some bullets as following screenshot.

![Example.jl with bullets](./assets/julia_lsp_result.png)

Then just quit `neovim` and continue and finish installation.
To test installation, open any example Julia file and change keyword `function` to
`func tion` and at the same line, input `gl`. If you have some bullets and
messages as following, your installation is successful.
![Success to install](./assets/julia_lsp_install_success.png)

If you have any error to load Julia LSP, you can find following errror message in `neovim`.
![Fail message](./assets/julia_lsp_error.png)

As you can find in the following, `LanguageServer` package depends on
`JuliaFormatter`, `StaticLint`, and `SymbolServer`. That means we do not have to
install `JuliaFormatter` separately.

```@example
using Pkg
Pkg.add("LanguageServer")

```

To format your code, you can find related commends in
[keymaps.lua](https://github.com/erdosxx/Neovim-from-scratch/blob/27_Julia_REPL/lua/user/keymaps.lua)
file. Type `:Format` in command or `<space key>f`(when `<localleader>` = `<space key>`)
in normal mode, whole code in the file will be formatted.

!!! info

    To get supported to Julia formatting, we can also try to use
    [JuliaFormatter.vim](https://github.com/kdheepak/JuliaFormatter.vim).
    This only supports formatting and no other LSP function but
    range format supporting in visual mode and
    definition of format option in configuration file are possible.
    This uses [JuliaFormatter](https://github.com/domluna/JuliaFormatter.jl)
    independently.
    However, I found that when we use Julia LSP with this package, LSP was
    crashed occasionally. So I decided to uninstall it.

To define format parameters in Julia code is not easy in
[LSP configuration file](https://github.com/erdosxx/Neovim-from-scratch/blob/27_Julia_REPL/lua/user/lsp/settings/julials.lua).
The solution is use ['.JuliaFormatter.toml'](https://domluna.github.io/JuliaFormatter.jl/dev/config/)
file in every repo. So it can be convenient to add this file to
PkgTemplates. (See below section)

!!! info

    The useful configuration to format is
    - style = "sciml"
    - indent = 2
    - margin = 79
    For style options, see [YAS](https://domluna.github.io/JuliaFormatter.jl/dev/yas_style/),
    [Blue](https://domluna.github.io/JuliaFormatter.jl/dev/blue_style/), and
    [SciML](https://domluna.github.io/JuliaFormatter.jl/dev/sciml_style/).

!!! tip

    The shortcut keys to use LSP is defined in
    [`handler.lua`](https://github.com/erdosxx/Neovim-from-scratch/blob/master/lua/user/lsp/handlers.lua)
    Some useful keys are
    - `gl`: read diagnostics messages
    - `gd`: Go the the definition
    - `K`: Get help for functions, variables and so on.
    - `gr`: Get references or usages of functions. Looks only supported in the same file.
    - `<leader>la`: Add code actions. For example add docstrings after definding function.
    - `<leader>lr`: rename function. Looks only supported in the same file.

## Use [PkgTemplates](https://github.com/JuliaCI/PkgTemplates.jl) to generate repository

PkgTemplates simplifies the process of setting up the initial file structure for
a new repository, specifically [CI](https://en.wikipedia.org/wiki/Continuous_integration)
integration with GitHub actions.
To use PkgTemplates, we recommend to install it in system default Julia environment,
for example, `v1.9` as following.

```julia
using Pkg
Pkg.activate()   # activate system default env
Pkg.add("PkgTemplates")
```

After installing it, we need to setup the template. It would be convenient to keep it
in the
[`startup.jl`](https://github.com/erdosxx/evoagile_configs/blob/master/julia/.julia/config/startup.jl)
file for easy reuse.
Because this file runs every time Julia starts up, we can utilize the generate
function as shown in the following example.

```julia
function genGithubRepo(userName::String, repoName::String)
  templateGithub = Template(;
    user = userName,
    dir = "~/localgit",
    julia = v"1",  # for [compat] section in Project.toml
    plugins = [
      # Use semantic version, See Julia Pattern book page 43.
      ProjectFile(; version = v"1.0.0-DEV"),
      License(; name = "MIT", path = nothing, destination = "LICENSE"),
      Git(;
        branch = LibGit2.getconfig("init.defaultBranch", "master"),
        ssh = true,
        jl = true,
        manifest = false),
      GitHubActions(;
        destination = "CI.yml",
        linux = true,
        osx = false,
        windows = false,
        x64 = true,
        x86 = false,
        coverage = true,
        extra_versions = ["1.8", "1.9", "nightly"]),
      CompatHelper(; destination = "CompatHelper.yml", cron = "0 0 * * *"),
      TagBot(;
        destination = "TagBot.yml",
        trigger = "JuliaTagBot",
        token = Secret("GITHUB_TOKEN"),
        ssh = Secret("DOCUMENTER_KEY"),
        ssh_password = nothing,
        changelog = nothing,
        changelog_ignore = nothing,
        gpg = nothing,
        gpg_password = nothing,
        registry = nothing,
        branches = nothing,
        dispatch = nothing,
        dispatch_delay = nothing),
      Codecov(),
      Documenter{GitHubActions}(logo = Logo(;
        light = homedir() * "/.config/logo/logo.png",
        dark = homedir() * "/.config/logo/logo-dark.png")),
      Dependabot(),
    ])
  generate(templateGithub, repoName)
end

genGithubRepo("ecoinfos", "JuliaStudy.jl")
```

To run above code, folowwing things are needed.

- Logo files in `$HOME/.config/logo`. For example, use `stow` command to my
  [evoagile_configs](https://github.com/erdosxx/evoagile_configs)
  repository to setup `evoagile` logos as following.

```shell
$ cd localgit/evoagile_configs
$ stow -t ~ logo
```

- DOCUMENTER_KEY.
  This is required for deploying documents and
  can be generated by [`DocumeterTools`](https://documenter.juliadocs.org/stable/man/hosting/#travis-ssh).

- [CompatHelper](https://github.com/JuliaRegistries/CompatHelper.jl) access permission to pull request.
  Go to GitHub organization(Ex. ecoinfos) -> settings -> Actions -> General and set options
  with `Read and write permissions` and `Allow GitHub Action to create and approve pull requests`.
  After this organization setting, we can setup repository setting as the same way.
  **That is, without organization setting, we cannot change permission in repository setting.**
  Without this options, you can get error messages as like this.

```json
{
    "message":"GitHub Actions is not permitted to create or approve pull requests.",
    "documentation_url":
    "[https://docs.github.com/rest/pulls/pulls#create-a-pull-request]
    (https://docs.github.com/rest/pulls/pulls#create-a-pull-request)"}""",
    HTTP.Exceptions.StatusError(403, "POST",
    ...
}
```

!!! info

    The initial version, v"1.0.0-DEV" looks a bit strange because it starts from
    1.0. However this is for
    [semantic versioning](https://pkgdocs.julialang.org/v1/compatibility/#Version-specifier-format).
    A major version number of zero is special—it basically means that every new release is breaking.
    See also,
    [design patterns book for julia](https://www.packtpub.com/product/hands-on-design-patterns-and-best-practices-with-julia/9781838648817)
    page 43.

## Use [GitHub-CLI](https://cli.github.com/) to create repository in GitHub

Because `PkgTemplates` only make repository in `localgit` folder we need to
register it in GitHub. Basically this can be possible in GitHub Web page
but [GitHub-CLI](https://cli.github.com/) tool make this more easy.
In Gentoo, we can install it as following.

```shell
$ sudo emerge -av github-cli
$ gh auth login
```

After some authentication step, we can access, create and sync
an example repository as following.

```shell
$ gh repo list "ecoinfos"   # check the list of repo in ecoinfos user.
$ gh repo create "ecoinfos/JuliaStudy.jl" --public

# This repo is required to publish document to GitHub.
$ gh repo create "ecoinfos/ecoinfos.github.io" --public

$ cd localgit/JuliaStudy
$ git push origin HEAD --tags
```

## Playing with [REPL](https://en.wikipedia.org/wiki/Read%E2%80%93eval%E2%80%93print_loop)

To setup REPL, [`andreypopp/julia-repl-vim`](https://github.com/andreypopp/julia-repl-vim) is installed in
[`newvim`](https://github.com/erdosxx/Neovim-from-scratch/blob/27_Julia_REPL/lua/user/plugins.lua)
(already installed in Neovim-from-scratch)
and Julia default environment as following.

```shell
$ julia    # install in default env.
julia> using Pkg; Pkg.add(url="https://github.com/andreypopp/julia-repl-vim")
```

Because the [`startup.jl`](https://github.com/erdosxx/evoagile_configs/blob/master/julia/.julia/config/startup.jl)
file contains required startup commands, we can use it without manual setup.

```julia
using REPLVim
@async REPLVim.serve()
```

Once REPL is launched in another terminal and open a Julia file,
we can connect the code to REPL by `:JuliaREPLConnect` or `<localleader>o`.

- `<localleader>o`: Connect current file to REPL. You need to connect every
  files to REPL if you want to send them.
- `<localleader>u`: In normal mode, send the cursor line to REPL.
  In visual mode, send all **lines** in the range to REPL.
- `<localleader>k`: In visual mode, send exact range to REPL.
  This is useful if you want to send a part of code in a line to REPL.
- `<localleader>/`: Format and send code whose block has same indented level.

!!! tip

    Above key mappings are same for Python REPL. So, you can use them to connect Qt Console to build REPL.

## Coding with snippets

To make coding more easy, a few snippets are defined in
[`julia.lua`](https://github.com/erdosxx/Neovim-from-scratch/blob/27_Julia_REPL/lua/user/LuaSnip/julia.lua). To add and understand the definition of them
you can refer to offical [LuaSnip](https://github.com/L3MON4D3/LuaSnip) site.
Some frequently used snippets are

- `def` : Define function. Type `df` at the beginning of a line,
  this automatically generates `function end` block.
  There are three fields to input and when finish one,
  you can shift to next field by [`<F2>`](https://github.com/erdosxx/Neovim-from-scratch/blob/27_Julia_REPL/ftplugin/julia.lua)
  key with ignoring any possible suggestions.
- `ds` : Define structure. Type `ds` at the beginning of a line,
  this generate `struct end` block. You also can find `->` mark in the screen
  and that means there are choices to select.
  Type `<Ctrol + h>` or `<Ctrol + l>` you can change
  the selection between `struct` and `mutable struct`.
  After selection one, type `<F2>` to go next field.

For more snippets, please refer to [`julia.lua`](https://github.com/erdosxx/Neovim-from-scratch/blob/27_Julia_REPL/lua/user/LuaSnip/julia.lua).

## Run tests and check documents

When you finish to setup environment and you can try to
run all tests in `JuliaStudy` repository as following.

```shell
$ cd ~/localgit/JuliaStudy
$ julia --project=.
julia> using Pkg
julia> Pkg.test()
...
Test Summary: | Pass  Broken  Total     Time
All Tests     |  316       1    317  4m53.5s
     Testing JuliaStudy tests passed
```

This is important to run all tests before you commit your codes.
If you have no error messages as above result, you
can submit your documents in Github.
The Broken test is skipped test for temporary exception.

To check the documents for `Documenter` tool, run `make.jl` in `docs` project as following.

```shell
$ cd ~/localgit/JuliaStudy/docs
$ julia --porject=.
julia> include("make.jl")
```

If you have an error as following,

```shell
julia> include("make.jl")
ERROR: LoadError: ArgumentError: Package JuliaStudy [d399ac94-384f-4751-bea9-3a8f3e663572]
is required but does not seem to be installed:
 - Run `Pkg.instantiate()` to install all recorded dependencies.
...
```

you need to add `JuliaStudy` as a development environment.

```shell
julia> Pkg.develop(path="..")
```

## Setup Julia Mono Nerd font with input method in Neovim

Julia uses unicodes extensively for mathematical symbols.
For example in chapter 9 of Julia Patters book,
"∘" is used for composed operator as following.

```shell
julia> top_story_id = first ∘ fetch_top_stories
```

To support unicode fully, I recommend to use
[Julia Mono font](https://juliamono.netlify.app/) with
[Nerd patch](https://github.com/mietzen/juliamono-nerd-font).
You can find full list of unicode in
[Julia Unicode Input](https://docs.julialang.org/en/v1/manual/unicode-input/) page.  
As this page shows, to input unicode like "∘" in REPL,
input `\circ` with tab key.
To support these kinds of shortcuts in Neovim, I defined
the Lua snippets in the file, `lur/user/LuaSnip/julia.lua`
as following code.

```lua
local math_symbs = {
	{ name = "alpha", symbol = "α" },
	{ name = "beta", symbol = "β" },
	{ name = "gamma", symbol = "γ" },
	{ name = "delta", symbol = "δ" },
	{ name = "Delta", symbol = "Δ" },
	{ name = "lambda", symbol = "λ" },
	{ name = "Lambda", symbol = "Λ" },
	{ name = "theta", symbol = "θ" },
	{ name = "mu", symbol = "μ" },
	{ name = "pi", symbol = "π" },
	{ name = "eta", symbol = "η" },
	{ name = "varphi", symbol = "φ" },
	{ name = "psi", symbol = "ψ" },
	{ name = "phi", symbol = "ϕ" },
	{ name = "epsilon", symbol = "ϵ" },
	{ name = "sigma", symbol = "σ" },
	{ name = "circ", symbol = "∘" },
    ...
}
```

So, for more unicode shortcuts in Noevim, we can add
additional symbols with shortcuts in the file.
To get the matching symbol with unicode point
or search symbol by name, refer to following Julia code.

```@example 1
using Glyphy
glyphy(0x02218)
```

```@example 1
glyphy("ring operator")
```

## To do or practice

1. Add '.JuliaFormatter.toml' file to `PkgTemplates` to define format option.
2. Try to understand GitHub security model with secret keys.
   See [SSH Deploy Keys Walkthrough](https://documenter.juliadocs.org/stable/man/hosting/walkthrough/#Adding-the-Public-Key-to-GitHub)
   and [security hardening for github actions](https://docs.github.com/en/actions/security-guides/security-hardening-for-github-actions).

## References

1. [Github repo: evoagile_configs](https://github.com/erdosxx/evoagile_configs)
2. [Github repo: Neovim-from-scratch/27-Julia-REPL](https://github.com/erdosxx/Neovim-from-scratch/tree/27_Julia_REPL)
3. [Setting up Julia lsp for Neovim](https://www.juliabloggers.com/setting-up-julia-lsp-for-neovim/)
4. [discourse: Neovim + LanguageServer.jl](https://discourse.julialang.org/t/neovim-languageserver-jl/37286/63?page=5)
5. [Hands-On Design Patterns and Best Practices with Julia](https://www.packtpub.com/product/hands-on-design-patterns-and-best-practices-with-julia/9781838648817)
