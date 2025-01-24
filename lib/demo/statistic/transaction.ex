defmodule Demo.Statistic.Transaction do
  use Ecto.Schema
  import Ecto.Changeset

  schema "transactions" do
    field :quantity, :integer
    field :total_price, :decimal
    field :transaction_date, :utc_datetime
    belongs_to :product, Demo.Products.Product  

    timestamps(type: :utc_datetime)
  end

  def changeset(transaction, attrs) do
    transaction
    |> cast(attrs, [:quantity, :total_price, :transaction_date, :product_id])
    |> validate_required([:quantity, :total_price, :transaction_date, :product_id])
  end
end
