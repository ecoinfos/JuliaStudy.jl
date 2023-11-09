module MediatorPattern

abstract type Widget end

mutable struct TextField <: Widget
  id::Symbol
  value::String
end

# extract numeric value from a text field
get_number(t::TextField) = parse(Float64, t.value)

# set text field from a numeric value
function set_number(t::TextField, x::Real)
  println("* ", t.id, " is being updated to ", x)
  t.value = string(x)
  return nothing
end

Base.@kwdef struct App
  amount_field::TextField
  interest_rate_field::TextField
  interest_amount_field::TextField
end

# Create an app (the mediator) with some defualt values
const app = App(amount_field = TextField(:amount, "100.00"),
  interest_rate_field = TextField(:interest_rate, "5"),
  interest_amount_field = TextField(:interest_amount, "5.00"))

function on_change_event(widget::Widget)
  notify(app, widget)
end

# Mediator logic - handling changes to the widget in this app
function notify(app::App, widget::Widget)
  if widget in (app.amount_field, app.interest_rate_field)
    new_interest = get_number(app.amount_field) *
                   get_number(app.interest_rate_field) / 100
    set_number(app.interest_amount_field, new_interest)
  end
end

# For testing purpose
function print_current_state()
  println("current amount = ", get_number(app.amount_field))
  println("current interest rate = ", get_number(app.interest_rate_field))
  println("current interest amount = ", get_number(app.interest_amount_field))
  println()
end

function test()
  # Show current state before testing
  print_current_state()

  # double principal amount from 100 to 200
  set_number(app.amount_field, 200)
  on_change_event(app.amount_field)
  print_current_state()
end

end
