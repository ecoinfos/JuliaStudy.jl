var documenterSearchIndex = {"docs":
[{"location":"ch0_setup_julia_env/#Setup-Julia-Repo-in-GitHub-with-Actions","page":"Setup Environments","title":"Setup Julia Repo in GitHub with Actions","text":"","category":"section"},{"location":"ch0_setup_julia_env/#Install-Julia","page":"Setup Environments","title":"Install Julia","text":"","category":"section"},{"location":"ch0_setup_julia_env/","page":"Setup Environments","title":"Setup Environments","text":"Basically if you are using Linux or Mac, you can easily install Julia by the package manager. For Gentoo, we can install it with portage as following.","category":"page"},{"location":"ch0_setup_julia_env/","page":"Setup Environments","title":"Setup Environments","text":"$ sudo emerge -av julia\n","category":"page"},{"location":"ch0_setup_julia_env/","page":"Setup Environments","title":"Setup Environments","text":"The problem to install Julia by Gentoo package manager is slow upgrade speed. In this time, July 27 2023, latest stable version version of Julia in the official site is 1.9.2 but Gentoo still has 1.8.5 as the latest one. To overcome this gap, according to the instruction in Julia GitHub we can easily install it by compiling source.","category":"page"},{"location":"ch0_setup_julia_env/","page":"Setup Environments","title":"Setup Environments","text":"$ cd localgit  <-- local git directory\n$ git clone https://github.com/JuliaLang/julia.git\n$ cd julia\n$ git checkout v1.9.2  <-- tag for latest version\n$ make\n$ ln -s julia ~/.local/bin/julia  <-- This should be earlier path than /usr/bin/julia","category":"page"},{"location":"ch0_setup_julia_env/#Setup-Julia-language-server-with-formatter-for-Neovim","page":"Setup Environments","title":"Setup Julia language server with formatter for Neovim","text":"","category":"section"},{"location":"ch0_setup_julia_env/","page":"Setup Environments","title":"Setup Environments","text":"info: Info\nThis setup is based on cloned Neovim-from-scratch and Github repo: evoagile_configs repo.","category":"page"},{"location":"ch0_setup_julia_env/","page":"Setup Environments","title":"Setup Environments","text":"To setup LSP(Language Server Protocol) with julials.lua file in Neovim-from-scratch, we need to setup nvim-lspconfig environment first. Using stow tool, we can copy Makefile to ~/.julia/environments/nvim-lspconfig/.","category":"page"},{"location":"ch0_setup_julia_env/","page":"Setup Environments","title":"Setup Environments","text":"$ cd localgit/evoagile_configs   <-- if your local cloned repo is in localgit\n$ stow -t ~ julia\n$ cd ~/.julia/environments/nvim-lspconfig/\n$ make","category":"page"},{"location":"ch0_setup_julia_env/","page":"Setup Environments","title":"Setup Environments","text":"After make command, neovim is launched and open Example.jl source file with some errors. If you wait a moment and no problem occur to install, you can find some bullets as following screenshot.","category":"page"},{"location":"ch0_setup_julia_env/","page":"Setup Environments","title":"Setup Environments","text":"(Image: Example.jl with bullets)","category":"page"},{"location":"ch0_setup_julia_env/","page":"Setup Environments","title":"Setup Environments","text":"Then just quit neovim and continue and finish installation. To test installation, open any example Julia file and change keyword function to func tion and at the same line, input gl. If you have some bullets and messages as following, your installation is successful. (Image: Success to install)","category":"page"},{"location":"ch0_setup_julia_env/","page":"Setup Environments","title":"Setup Environments","text":"If you have any error to load Julia LSP, you can find following errror message in neovim. (Image: Fail message)","category":"page"},{"location":"ch0_setup_julia_env/","page":"Setup Environments","title":"Setup Environments","text":"As you can find in the following, LanguageServer package depends on JuliaFormatter, StaticLint, and SymbolServer. That means we do not have to install JuliaFormatter separately.","category":"page"},{"location":"ch0_setup_julia_env/","page":"Setup Environments","title":"Setup Environments","text":"using Pkg\nPkg.add(\"LanguageServer\")\n","category":"page"},{"location":"ch0_setup_julia_env/","page":"Setup Environments","title":"Setup Environments","text":"To format your code, you can find related commends in keymaps.lua file. Type :Format in command or <space key>f(when <localleader> = <space key>) in normal mode, whole code in the file will be formatted.","category":"page"},{"location":"ch0_setup_julia_env/","page":"Setup Environments","title":"Setup Environments","text":"info: Info\nTo get supported to Julia formatting, we can also try to use JuliaFormatter.vim. This only supports formatting and no other LSP function but range format supporting in visual mode and definition of format option in configuration file are possible. This uses JuliaFormatter independently. However, I found that when we use Julia LSP with this package, LSP was crashed occasionally. So I decided to uninstall it.","category":"page"},{"location":"ch0_setup_julia_env/","page":"Setup Environments","title":"Setup Environments","text":"To define format parameters in Julia code is not easy in LSP configuration file. The solution is use '.JuliaFormatter.toml' file in every repo. So it can be convenient to add this file to PkgTemplates. (See below section)","category":"page"},{"location":"ch0_setup_julia_env/","page":"Setup Environments","title":"Setup Environments","text":"info: Info\nThe useful configuration to format isstyle = \"sciml\"\nindent = 2\nmargin = 79For style options, see YAS, Blue, and SciML.","category":"page"},{"location":"ch0_setup_julia_env/","page":"Setup Environments","title":"Setup Environments","text":"tip: Tip\nThe shortcut keys to use LSP is defined in [handler.lua](https://github.com/erdosxx/Neovim-from-scratch/blob/master/lua/user/lsp/handlers.lua) Some useful keys aregl: read diagnostics messages\ngd: Go the the definition\nK: Get help for functions, variables and so on.\ngr: Get references or usages of functions. Looks only supported in the same file.\n<leader>la: Add code actions. For example add docstrings after definding function.\n<leader>lr: rename function. Looks only supported in the same file.","category":"page"},{"location":"ch0_setup_julia_env/#Use-[PkgTemplates](https://github.com/JuliaCI/PkgTemplates.jl)-to-generate-repository","page":"Setup Environments","title":"Use PkgTemplates to generate repository","text":"","category":"section"},{"location":"ch0_setup_julia_env/","page":"Setup Environments","title":"Setup Environments","text":"PkgTemplates simplifies the process of setting up the initial file structure for a new repository, specifically CI integration with GitHub actions. To use PkgTemplates, we recommend to install it in system default Julia environment, for example, v1.9 as following.","category":"page"},{"location":"ch0_setup_julia_env/","page":"Setup Environments","title":"Setup Environments","text":"using Pkg\nPkg.activate()   # activate system default env\nPkg.add(\"PkgTemplates\")","category":"page"},{"location":"ch0_setup_julia_env/","page":"Setup Environments","title":"Setup Environments","text":"After installing it, we need to setup the template. It would be convenient to keep it in the startup.jl file for easy reuse. Because this file runs every time Julia starts up, we can utilize the generate function as shown in the following example.","category":"page"},{"location":"ch0_setup_julia_env/","page":"Setup Environments","title":"Setup Environments","text":"function genGithubRepo(userName::String, repoName::String)\n  templateGithub = Template(;\n    user = userName,\n    dir = \"~/localgit\",\n    julia = v\"1\",  # for [compat] section in Project.toml\n    plugins = [\n      # Use semantic version, See Julia Pattern book page 43.\n      ProjectFile(; version = v\"1.0.0-DEV\"),\n      License(; name = \"MIT\", path = nothing, destination = \"LICENSE\"),\n      Git(;\n        branch = LibGit2.getconfig(\"init.defaultBranch\", \"master\"),\n        ssh = true,\n        jl = true,\n        manifest = false),\n      GitHubActions(;\n        destination = \"CI.yml\",\n        linux = true,\n        osx = false,\n        windows = false,\n        x64 = true,\n        x86 = false,\n        coverage = true,\n        extra_versions = [\"1.8\", \"1.9\", \"nightly\"]),\n      CompatHelper(; destination = \"CompatHelper.yml\", cron = \"0 0 * * *\"),\n      TagBot(;\n        destination = \"TagBot.yml\",\n        trigger = \"JuliaTagBot\",\n        token = Secret(\"GITHUB_TOKEN\"),\n        ssh = Secret(\"DOCUMENTER_KEY\"),\n        ssh_password = nothing,\n        changelog = nothing,\n        changelog_ignore = nothing,\n        gpg = nothing,\n        gpg_password = nothing,\n        registry = nothing,\n        branches = nothing,\n        dispatch = nothing,\n        dispatch_delay = nothing),\n      Codecov(),\n      Documenter{GitHubActions}(logo = Logo(;\n        light = homedir() * \"/.config/logo/logo.png\",\n        dark = homedir() * \"/.config/logo/logo-dark.png\")),\n      Dependabot(),\n    ])\n  generate(templateGithub, repoName)\nend\n\ngenGithubRepo(\"ecoinfos\", \"JuliaStudy.jl\")","category":"page"},{"location":"ch0_setup_julia_env/","page":"Setup Environments","title":"Setup Environments","text":"To run above code, folowwing things are needed.","category":"page"},{"location":"ch0_setup_julia_env/","page":"Setup Environments","title":"Setup Environments","text":"Logo files in $HOME/.config/logo. For example, use stow command to my evoagile_configs repository to setup evoagile logos as following.","category":"page"},{"location":"ch0_setup_julia_env/","page":"Setup Environments","title":"Setup Environments","text":"$ cd localgit/evoagile_configs\n$ stow -t ~ logo","category":"page"},{"location":"ch0_setup_julia_env/","page":"Setup Environments","title":"Setup Environments","text":"DOCUMENTER_KEY. This is required for deploying documents and can be generated by DocumeterTools.\nCompatHelper access permission to pull request. Go to GitHub organization(Ex. ecoinfos) -> settings -> Actions -> General and set options with Read and write permissions and Allow GitHub Action to create and approve pull requests. After this organization setting, we can setup repository setting as the same way. That is, without organization setting, we cannot change permission in repository setting. Without this options, you can get error messages as like this.","category":"page"},{"location":"ch0_setup_julia_env/","page":"Setup Environments","title":"Setup Environments","text":"{\n    \"message\":\"GitHub Actions is not permitted to create or approve pull requests.\",\n    \"documentation_url\":\n    \"[https://docs.github.com/rest/pulls/pulls#create-a-pull-request]\n    (https://docs.github.com/rest/pulls/pulls#create-a-pull-request)\"}\"\"\",\n    HTTP.Exceptions.StatusError(403, \"POST\",\n    ...\n}","category":"page"},{"location":"ch0_setup_julia_env/","page":"Setup Environments","title":"Setup Environments","text":"info: Info\nThe initial version, v\"1.0.0-DEV\" looks a bit strange because it starts from 1.0. However this is for semantic versioning. A major version number of zero is special—it basically means that every new release is breaking. See also, design patterns book for julia page 43.","category":"page"},{"location":"ch0_setup_julia_env/#Use-[GitHub-CLI](https://cli.github.com/)-to-create-repository-in-GitHub","page":"Setup Environments","title":"Use GitHub-CLI to create repository in GitHub","text":"","category":"section"},{"location":"ch0_setup_julia_env/","page":"Setup Environments","title":"Setup Environments","text":"Because PkgTemplates only make repository in localgit folder we need to register it in GitHub. Basically this can be possible in GitHub Web page but GitHub-CLI tool make this more easy. In Gentoo, we can install it as following.","category":"page"},{"location":"ch0_setup_julia_env/","page":"Setup Environments","title":"Setup Environments","text":"$ sudo emerge -av github-cli\n$ gh auth login","category":"page"},{"location":"ch0_setup_julia_env/","page":"Setup Environments","title":"Setup Environments","text":"After some authentication step, we can access, create and sync an example repository as following.","category":"page"},{"location":"ch0_setup_julia_env/","page":"Setup Environments","title":"Setup Environments","text":"$ gh repo list \"ecoinfos\"   # check the list of repo in ecoinfos user.\n$ gh repo create \"ecoinfos/JuliaStudy.jl\" --public\n\n# This repo is required to publish document to GitHub.\n$ gh repo create \"ecoinfos/ecoinfos.github.io\" --public\n\n$ cd localgit/JuliaStudy\n$ git push origin HEAD --tags","category":"page"},{"location":"ch0_setup_julia_env/#Playing-with-[REPL](https://en.wikipedia.org/wiki/Read%E2%80%93eval%E2%80%93print_loop)","page":"Setup Environments","title":"Playing with REPL","text":"","category":"section"},{"location":"ch0_setup_julia_env/","page":"Setup Environments","title":"Setup Environments","text":"To setup REPL, andreypopp/julia-repl-vim is installed in newvim (already installed in Neovim-from-scratch) and Julia default environment as following.","category":"page"},{"location":"ch0_setup_julia_env/","page":"Setup Environments","title":"Setup Environments","text":"$ julia    # install in default env.\njulia> using Pkg; Pkg.add(\"url=\"https://github.com/andreypopp/julia-repl-vim\"\")","category":"page"},{"location":"ch0_setup_julia_env/","page":"Setup Environments","title":"Setup Environments","text":"Because the startup.jl file contains required startup commands, we can use it without manual setup.","category":"page"},{"location":"ch0_setup_julia_env/","page":"Setup Environments","title":"Setup Environments","text":"using REPLVim\n@async REPLVim.serve()","category":"page"},{"location":"ch0_setup_julia_env/","page":"Setup Environments","title":"Setup Environments","text":"Once REPL is launched in another terminal and open a Julia file, we can connect the code to REPL by :JuliaREPLConnect or <localleader>o. To send some codes to REPL,","category":"page"},{"location":"ch0_setup_julia_env/","page":"Setup Environments","title":"Setup Environments","text":"<localleader>u: In normal mode, send the cursor line to REPL. In visual mode, send the range to REPL.\n<localleader>/: Format and send code whose block has same indented level.","category":"page"},{"location":"ch0_setup_julia_env/#References","page":"Setup Environments","title":"References","text":"","category":"section"},{"location":"ch0_setup_julia_env/","page":"Setup Environments","title":"Setup Environments","text":"Github repo: evoagile_configs\nGithub repo: Neovim-from-scratch/27-Julia-REPL\nSetting up Julia lsp for Neovim\ndiscourse: Neovim + LanguageServer.jl\nHands-On Design Patterns and Best Practices with Julia","category":"page"},{"location":"Julia2ndLang/ch16_organizing_and_modularizing_your_code/#Organizing-and-modularizing-your-code","page":"Setup Packages","title":"Organizing and modularizing your code","text":"","category":"section"},{"location":"Julia2ndLang/ch1_why_julia/#Why-Julia?","page":"Why Julia?","title":"Why Julia?","text":"","category":"section"},{"location":"Julia2ndLang/ch2_julia_as_a_calculator/#Julia-as-a-calculator","page":"Julia as a Calculator","title":"Julia as a calculator","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"CurrentModule = JuliaStudy","category":"page"},{"location":"#Study-Schedule-(2023)","page":"Home","title":"Study Schedule (2023)","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"Date Range Presenter\nAug 3 Setup Julia Repo in GitHub with Actions Norel\nAug 10 Why Julia? Kjeong\nAug 17 Organizing and modularizing your code Norel\nAug 24 Julia as a calculator Kjeong","category":"page"},{"location":"","page":"Home","title":"Home","text":"Documentation for JuliaStudy.","category":"page"},{"location":"","page":"Home","title":"Home","text":"","category":"page"},{"location":"","page":"Home","title":"Home","text":"Modules = [JuliaStudy]","category":"page"}]
}