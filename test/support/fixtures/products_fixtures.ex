defmodule Demo.ProductsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Demo.Products` context.
  """

  @doc """
  Generate a product.
  """
  def product_fixture(attrs \\ %{}) do
    {:ok, product} =
      attrs
      |> Enum.into(%{
        category: "some category",
        description: "some description",
        photo: "some photo",
        price: "120.5",
        stock: 42,
        title: "some title"
      })
      |> Demo.Products.create_product()

    product
  end
end
