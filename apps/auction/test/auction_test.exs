defmodule AuctionTest do
  use ExUnit.Case
  alias Auction.{Item, Repo}
  doctest Auction

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Repo)
  end

  test "the truth" do
    assert true
  end

  describe "list_items/0" do
    # ... tests
    setup do
      # insert items into db
      {:ok, item1} = Repo.insert(%Item{title: "Item 1"})
      {:ok, item2} = Repo.insert(%Item{title: "Item 2"})
      {:ok, item3} = Repo.insert(%Item{title: "Item 3"})

      # return a Map with a List of inserted items as the context
      %{items: [item1, item2, item3]}
    end

    test "returns all Items in the database", %{items: items} do
      assert items == Auction.list_items()
    end
  end
end
