# this helper will be executed before every test run
# you can put any setup code you need to run before your tests in this file
ExUnit.start()

Ecto.Adapters.SQL.Sandbox.mode(Auction.Repo, :manual)
