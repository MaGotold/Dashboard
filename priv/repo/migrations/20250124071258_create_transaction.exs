defmodule Demo.Repo.Migrations.CreateTransactions do
  use Ecto.Migration

  def change do
    create table(:transactions) do
      add :quantity, :integer
      add :total_price, :decimal
      add :transaction_date, :utc_datetime
      add :product_id, references(:products, on_delete: :nothing)  # Foreign key to products table

      timestamps(type: :utc_datetime)
    end

    create index(:transactions, [:product_id])  # Index to optimize querying by product_id
  end
end
