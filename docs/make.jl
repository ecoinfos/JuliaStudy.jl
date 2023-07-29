using JuliaStudy
using Documenter

DocMeta.setdocmeta!(JuliaStudy,
  :DocTestSetup,
  :(using JuliaStudy);
  recursive = true)

makedocs(;
  modules = [JuliaStudy],
  authors = "Norel <norel.evoagile@gmail.com> and contributors",
  repo = "https://github.com/ecoinfos/JuliaStudy.jl/blob/{commit}{path}#{line}",
  sitename = "JuliaStudy.jl",
  format = Documenter.HTML(;
    prettyurls = get(ENV, "CI", "false") == "true",
    canonical = "https://ecoinfos.github.io/JuliaStudy.jl",
    edit_link = "master",
    assets = String[]),
  pages = [
    "Home" => "index.md",
    "Julia as a Second Language" =>
      Any[
        "Setup Environments" => "Julia2ndLang/ch0_setup_julia_env.md",
        "Why Julia?" => "Julia2ndLang/ch1_why_julia.md",
        "Setup Packages" => "Julia2ndLang/ch16_organizing_and_modularizing_your_code.md",
        "Julia as a Calculator" => "Julia2ndLang/ch2_julia_as_a_calculator.md",
      ],
  ]
)

deploydocs(;
  repo = "github.com/ecoinfos/JuliaStudy.jl",
  devbranch = "master")
