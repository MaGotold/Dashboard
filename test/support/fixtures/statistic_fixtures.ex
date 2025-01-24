defmodule Demo.StatisticFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Demo.Statistic` context.
  """

  @doc """
  Generate a transaction.
  """
  def transaction_fixture(attrs \\ %{}) do
    {:ok, transaction} =
      attrs
      |> Enum.into(%{
        quantity: 42,
        total_price: "120.5",
        transaction_date: ~U[2025-01-23 07:12:00Z]
      })
      |> Demo.Statistic.create_transaction()

    transaction
  end
end
