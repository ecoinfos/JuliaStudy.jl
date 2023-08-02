using JuliaStudy
using Documenter

DocMeta.setdocmeta!(JuliaStudy,
  :DocTestSetup,
  :(using JuliaStudy);
  recursive=true)

makedocs(;
  modules=[JuliaStudy],
  authors="Norel <norel.evoagile@gmail.com> and contributors",
  repo="https://github.com/ecoinfos/JuliaStudy.jl/blob/{commit}{path}#{line}",
  sitename="JuliaStudy.jl",
  format=Documenter.HTML(;
    prettyurls=get(ENV, "CI", "false") == "true",
    canonical="https://ecoinfos.github.io/JuliaStudy.jl",
    edit_link="master",
    assets=String[]),
  pages=[
    "Home" => "index.md",
    "Setup environments" => "ch0_setup_julia_env.md",
    "Julia as a Second Language" =>
      Any[
        "Why Julia?"=>"Julia2ndLang/ch1_why_julia.md",
        "Organizing and modularizing your code"=>"Julia2ndLang/ch16_organizing_and_modularizing_your_code.md",
        "Julia as a calculator"=>"Julia2ndLang/ch2_julia_as_a_calculator.md",
        "Control flow"=>"Julia2ndLang/ch3_control_flow.md",
        "Julias as a spreadsheet"=>"Julia2ndLang/ch4_julia_as_a_spreadsheet.md",
        "Working with test"=>"Julia2ndLang/ch5_working_with_text.md",
        "Storing data in dictionaries"=>"Julia2ndLang/ch6_storing_data_in_dictionaries.md",
        "Understanding types"=>"Julia2ndLang/ch7_understanding_types.md",
      ],
    "Hands-On Design Patterns and Best Practices with Julia" =>
      Any[
        "Modules, Packages, and Data Type Concepts"=>"JuliaPatterns/ch2_modules_packages_and_data_type_concepts.md",
      ],
  ]
)

deploydocs(;
  repo="github.com/ecoinfos/JuliaStudy.jl",
  devbranch="master")
