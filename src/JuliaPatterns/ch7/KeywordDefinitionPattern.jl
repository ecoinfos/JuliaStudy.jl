module KeywordDefinitionPattern
export TextStyle, TextStyle2

struct TextStyle
  font_family::Any
  font_size::Any
  font_weight::Any
  foreground_color::Any
  background_color::Any
  alignment::Any
  rotation::Any
end

function TextStyle(;
  font_family,
  font_size,
  font_weight = "Normal",
  foreground_color = "black",
  background_color = "white",
  alignment = "left",
  rotation = 0)
  return TextStyle(font_family,
    font_size,
    font_weight,
    foreground_color,
    background_color,
    alignment,
    rotation)
end

@kwdef struct TextStyle2
  font_family::Any
  font_size::Any
  font_weight = "Normal"
  foreground_color = "black"
  background_color = "white"
  alignment = "center"
  rotation = 0
end

end
