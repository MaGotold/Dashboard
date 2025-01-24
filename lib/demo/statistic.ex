defmodule Demo.Statistic do
  @moduledoc """
  The Statistic context.
  """

  import Ecto.Query, warn: false
  alias Demo.Repo

  alias Demo.Statistic.Transaction
  alias Demo.Products.Product

  @doc """
  Returns the list of transaction.

  ## Examples

      iex> list_transaction()
      [%Transaction{}, ...]

  """
  def list_transaction do
    Repo.all(Transaction)
  end

  @doc """
  Gets a single transaction.

  Raises `Ecto.NoResultsError` if the Transaction does not exist.

  ## Examples

      iex> get_transaction!(123)
      %Transaction{}

      iex> get_transaction!(456)
      ** (Ecto.NoResultsError)

  """
  def get_transaction!(id), do: Repo.get!(Transaction, id)

  @doc """
  Creates a transaction.

  ## Examples

      iex> create_transaction(%{field: value})
      {:ok, %Transaction{}}

      iex> create_transaction(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_transaction(attrs \\ %{}) do
    %Transaction{}
    |> Transaction.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a transaction.

  ## Examples

      iex> update_transaction(transaction, %{field: new_value})
      {:ok, %Transaction{}}

      iex> update_transaction(transaction, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_transaction(%Transaction{} = transaction, attrs) do
    transaction
    |> Transaction.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a transaction.

  ## Examples

      iex> delete_transaction(transaction)
      {:ok, %Transaction{}}

      iex> delete_transaction(transaction)
      {:error, %Ecto.Changeset{}}

  """
  def delete_transaction(%Transaction{} = transaction) do
    Repo.delete(transaction)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking transaction changes.

  ## Examples

      iex> change_transaction(transaction)
      %Ecto.Changeset{data: %Transaction{}}

  """
  def change_transaction(%Transaction{} = transaction, attrs \\ %{}) do
    Transaction.changeset(transaction, attrs)
  end

  def get_total_stock do
    # Create a query to sum the 'stock' field
    query = from p in Product, select: sum(p.stock)
    # Execute the query and return the sum, defaulting to 0 if the result is nil
    Repo.one(query) || 0
  end


  def get_best_selling_products do
    # Create a query that joins the Product table and groups by product_id and product title
    query = from t in Transaction,
            join: p in Product, on: p.id == t.product_id,  # Assuming Product has an `id` field
            group_by: [t.product_id, p.title],  # Grouping by both product_id and product title
            select: %{product_title: p.title, total_sales: sum(t.total_price)},
            order_by: [desc: sum(t.total_price)]  # Ordering by total_sales in descending order

    # Execute the query to get the total sales and product titles
    Repo.all(query)
  end


  def get_product_sales_by_month(year, month) do
    # Query to get sales by product for the selected month
    query = from t in Transaction,
            join: p in Product, on: p.id == t.product_id,  # Assuming Product table has id and is related to Transaction
            where: fragment("EXTRACT(YEAR FROM ?)", t.transaction_date) == ^year and fragment("EXTRACT(MONTH FROM ?)", t.transaction_date) == ^month,
            group_by: [p.id, p.title],  # Grouping by product id and title
            select: %{product_title: p.title, total_quantity: sum(t.quantity)}

    # Execute the query
    product_sales = Repo.all(query)

    # Now, we calculate the total sum of all product quantities for the selected month
    total_quantity_query = from t in Transaction,
                            where: fragment("EXTRACT(YEAR FROM ?)", t.transaction_date) == ^year and fragment("EXTRACT(MONTH FROM ?)", t.transaction_date) == ^month,
                            select: sum(t.quantity)

    total_quantity = Repo.one(total_quantity_query)

    {product_sales, total_quantity}
  end
end
