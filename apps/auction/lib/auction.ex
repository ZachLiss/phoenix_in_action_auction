defmodule Auction do
  import Ecto.Query

  alias Auction.{Repo, Item, User, Password, Bid}

  @repo Repo

  # item related functions
  def list_items do
    @repo.all(Item)
  end

  def get_item(id) do
    @repo.get!(Item, id)
  end

  def get_item_with_bids(id) do
    id
    |> get_item()
    |> @repo.preload(bids: from(b in Bid, order_by: [desc: b.inserted_at]))
    |> @repo.preload(bids: [:user])
  end

  def get_item_by(attrs) do
    @repo.get_by(Item, attrs)
  end

  def insert_item(attrs) do
    %Item{}
    |> Item.changeset(attrs)
    |> @repo.insert()
  end

  def delete_item(%Item{} = item) do
    @repo.delete(item)
  end

  def update_item(%Item{} = item, updates) do
    item
    |> Item.changeset(updates)
    |> @repo.update()
  end

  def new_item() do
    Item.changeset(%Item{})
  end

  def edit_item(id) do
    get_item(id)
    |> Item.changeset()
  end

  # user related functions
  def get_user(id) do
    @repo.get!(User, id)
  end

  @doc """
  Retrieves a User from the database matching the provided username and password

  ## Return values

  Depending on what is found in the database, two different values could be returned:

  * an `Auction.User` struct: An `Auction.User` record was found that matched
  the `username` and `password` that was provided.
  * `false`: No `Auction.User` could be found with the provided `username` and `password`

  You can then use the returned value to determine wheter or not the User is authorized
  in your application. If an `Auction.User` is _not_ found based on `username`, the
  computational work of hash a password is still done

  ## Examples

  		iex> get_user_by_username_and_password("no_user", "bad_password")
  		false

  		iex> insert_user(%{username: "geo", password: "example", password_confirmation: "example", email_address: "test@example.com"})
  		...> result = get_user_by_username_and_password("geo", "example")
  		...> match?(%Auction.User{username: "geo"}, result)
  		true
  """
  def get_user_by_username_and_password(username, password) do
    with user when not is_nil(user) <- @repo.get_by(User, %{username: username}),
         true <- Password.verify_with_hash(password, user.hashed_password) do
      user
    else
      _ -> Password.dummy_verify()
    end
  end

  def new_user() do
    User.changeset_with_password(%User{})
  end

  def insert_user(attrs) do
    %User{}
    |> User.changeset_with_password(attrs)
    |> @repo.insert()
  end

  # bid related functions
  def insert_bid(attrs) do
    %Bid{}
    |> Bid.changeset(attrs)
    |> @repo.insert()
  end

  def new_bid() do
    Bid.changeset(%Bid{})
  end

  def get_bids_for_user(%User{} = user) do
    query =
      from(b in Bid,
        where: b.user_id == ^user.id,
        order_by: [desc: :inserted_at],
        preload: :item,
        limit: 10
      )

    @repo.all(query)
  end
end
