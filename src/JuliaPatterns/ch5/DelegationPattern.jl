module DelegationPattern

using Dates
using Lazy: @forward

export SavingsAccount, balance, deposit!

mutable struct Account
  account_number::String
  balance::Float64
  date_opened::Date
end

# Accessors
account_number(a::Account) = a.account_number
balance(a::Account) = a.balance
date_opened(a::Account) = a.date_opened

# Functions
function deposit!(a::Account, amount::Real)
  a.balance += amount
  return a.balance
end

function withdraw!(a::Account, amount::Real)
  a.balance -= amount
  return a.balance
end

function transfer!(from::Account, to::Account, amount::Real)
  withdraw!(from, amount)
  deposit!(to, amount)
  return amount
end

struct SavingsAccount
  acct::Account
  interest_rate::Float64
  function SavingsAccount(account_number::String,
    balance::Float64,
    date_opened::Date,
    interest_rate::Float64)
    new(Account(account_number, balance, date_opened), interest_rate)
  end
end

# Forward assessors
account_number(sa::SavingsAccount) = account_number(sa.acct)
balance(sa::SavingsAccount) = balance(sa.acct)
date_opened(sa::SavingsAccount) = date_opened(sa.acct)

# Forward methods
deposit!(sa::SavingsAccount, amount::Real) = deposit!(sa.acct, amount)
withdraw!(sa::SavingsAccount, amount::Real) = withdraw!(sa.acct, amount)
function transfer!(from::SavingsAccount, to::SavingsAccount, amount::Real)
  transfer!(from.acct, to.acct, amount)
end

# New accessor
interest_rate(sa::SavingsAccount) = sa.interest_rate

# New behavior
function accrue_daily_interest!(sa::SavingsAccount)
  interest = balance(sa) * interest_rate(sa) / 365
  deposit!(sa, interest)
end

# Forward assessors and functions
@forward SavingsAccount.acct account_number, balance, date_opened
@forward SavingsAccount.acct deposit!, withdraw!
function transfer!(from::SavingsAccount, to::SavingsAccount, amount::Real)
  transfer!(from.acct, to.acct, amount)
end

end
