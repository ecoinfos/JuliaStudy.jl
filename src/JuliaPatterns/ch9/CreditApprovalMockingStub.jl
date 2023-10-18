module CreditApprovalMockingStub

using Mocking

# primary function to open an account
# function open_account(first_name, last_name, email) end

# supportive functions
# function check_background(first_name, last_name) end
function create_account(first_name, last_name, email) end
# function notify_downstream(account_number) end

# Background check.
# In practice, we would call a remote service for this.
# For this exmaple, we just return true.
function check_background(first_name, last_name)
  println("Doing background check for $first_name $last_name")
  return true
end

# Notify downstream system by sending a message.
# For this example, we just print to console and return nothing.
function notify_downstream(account_number)
  println("Notifying downstream system about new account $account_number")
  return nothing
end

function open_account(first_name, last_name, email)
  @mock(check_background(first_name, last_name)) || return :failure
  account_number = @mock(create_account(first_name, last_name, email))
  @mock(notify_downstream(account_number))
  return :success
end

end
