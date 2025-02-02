defmodule Demo.Products do
  @moduledoc """
  The Products context.
  """

  import Ecto.Query, warn: false
  alias Demo.Repo

  alias Demo.Products.Product

  @doc """
  Returns the list of products.

  ## Examples

      iex> list_products()
      [%Product{}, ...]

  """
 def list_products(filters \\ %{}) do
  query = from(p in Product)

  # Apply category filter if present
  query = case filters[:category] do
    "" -> query
    nil -> query
    category -> from(p in query, where: p.category == ^category)
  end

  # Apply price sorting if present
  query = case filters[:price_sort] do
    "asc" -> from(p in query, order_by: [asc: p.price])
    "desc" -> from(p in query, order_by: [desc: p.price])
    _ -> query
  end

  Repo.all(query)
end


  @doc """
  Gets a single product.

  Raises `Ecto.NoResultsError` if the Product does not exist.

  ## Examples

      iex> get_product!(123)
      %Product{}

      iex> get_product!(456)
      ** (Ecto.NoResultsError)

  """
  def get_product!(id), do: Repo.get!(Product, id)

  @doc """
  Creates a product.

  ## Examples

      iex> create_product(%{field: value})
      {:ok, %Product{}}

      iex> create_product(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_product(attrs \\ %{}) do
    %Product{}
    |> Product.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a product.

  ## Examples

      iex> update_product(product, %{field: new_value})
      {:ok, %Product{}}

      iex> update_product(product, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_product(%Product{} = product, attrs) do
    product
    |> Product.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a product.

  ## Examples

      iex> delete_product(product)
      {:ok, %Product{}}

      iex> delete_product(product)
      {:error, %Ecto.Changeset{}}

  """
  def delete_product(%Product{id: id}) do
    product = Repo.get(Product, id)

    case product do
      nil ->
        {:error, :not_found}
      %Product{} ->
        Repo.delete(product)
    end
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking product changes.

  ## Examples

      iex> change_product(product)
      %Ecto.Changeset{data: %Product{}}

  """
  def change_product(%Product{} = product, attrs \\ %{}) do
    Product.changeset(product, attrs)
  end
end
