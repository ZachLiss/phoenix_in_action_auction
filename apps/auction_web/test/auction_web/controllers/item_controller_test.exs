defmodule AuctionWeb.ItemControllerTest do
  use AuctionWeb.ConnCase

  # different from textbook.. looks like we need to
  # explicitly checkout a connection to the db now?
  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Auction.Repo)
  end

  test "GET /", %{conn: conn} do
    {:ok, _item} = Auction.insert_item(%{title: "test item"})
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "test item"
  end
end
