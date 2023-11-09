module AbstractFactoryPattern

abstract type OS end
struct MacOS <: OS end
struct Windows <: OS end

abstract type Button end
Base.show(io::IO, x::Button) = print(io, "'$(x.text)' button")

abstract type Label end
Base.show(io::IO, x::Label) = print(io, "'$(x.text)' label")

# Button
struct MacOSButton <: Button
  text::String
end

struct WindowsButton <: Button
  text::String
end

# Label
struct MacOSLabel <: Label
  text::String
end

struct WindowsLabel <: Label
  text::String
end

# Generic implementation using traits
current_os() = MacOS() # should get from system
make_button(text::String) = make_button(current_os(), text)
make_label(text::String) = make_label(current_os(), text)

# MacOS implementation
make_button(::MacOS, text::String) = MacOSButton(text)
make_label(::MacOS, text::String) = MacOSLabel(text)

# Windows implementation
make_button(::Windows, text::String) = WindowsButton(text)
make_label(::Windows, text::String) = WindowsLabel(text)

end
