# ran
# > MIX_ENV=test mix do ecto.create, ecto.migrate
# in order to setup the new auction_test db
use Mix.Config

config :auction, Auction.Repo,
  database: "auction_test",
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  port: "5432",
  pool: Ecto.Adapters.SQL.Sandbox

config :logger, level: :info
