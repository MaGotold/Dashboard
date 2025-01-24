defmodule Demo.Products.Product do
  use Ecto.Schema
  import Ecto.Changeset

  schema "products" do
    field :description, :string
    field :title, :string
    field :category, :string
    field :photo, :string
    field :price, :decimal
    field :stock, :integer

    belongs_to :user, Demo.Users.User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(product, attrs \\ %{}) do
    product
    |> cast(attrs, [:photo, :title, :description, :category, :price, :stock, :user_id])
    |> validate_required([:photo, :title, :category, :price, :stock, :user_id])
  end

  def change_product(product) do
    changeset(product, %{})
  end
end
