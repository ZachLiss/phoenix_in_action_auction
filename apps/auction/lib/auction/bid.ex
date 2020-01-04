defmodule Auction.Bid do
  use Ecto.Schema

  import Ecto.Changeset

  schema "bids" do
    field(:amount, :integer)
    timestamps()
  end
end
