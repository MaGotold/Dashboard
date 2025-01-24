defmodule Demo.StatisticTest do
  use Demo.DataCase

  alias Demo.Statistic

  describe "transaction" do
    alias Demo.Statistic.Transaction

    import Demo.StatisticFixtures

    @invalid_attrs %{quantity: nil, total_price: nil, transaction_date: nil}

    test "list_transaction/0 returns all transaction" do
      transaction = transaction_fixture()
      assert Statistic.list_transaction() == [transaction]
    end

    test "get_transaction!/1 returns the transaction with given id" do
      transaction = transaction_fixture()
      assert Statistic.get_transaction!(transaction.id) == transaction
    end

    test "create_transaction/1 with valid data creates a transaction" do
      valid_attrs = %{quantity: 42, total_price: "120.5", transaction_date: ~U[2025-01-23 07:12:00Z]}

      assert {:ok, %Transaction{} = transaction} = Statistic.create_transaction(valid_attrs)
      assert transaction.quantity == 42
      assert transaction.total_price == Decimal.new("120.5")
      assert transaction.transaction_date == ~U[2025-01-23 07:12:00Z]
    end

    test "create_transaction/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Statistic.create_transaction(@invalid_attrs)
    end

    test "update_transaction/2 with valid data updates the transaction" do
      transaction = transaction_fixture()
      update_attrs = %{quantity: 43, total_price: "456.7", transaction_date: ~U[2025-01-24 07:12:00Z]}

      assert {:ok, %Transaction{} = transaction} = Statistic.update_transaction(transaction, update_attrs)
      assert transaction.quantity == 43
      assert transaction.total_price == Decimal.new("456.7")
      assert transaction.transaction_date == ~U[2025-01-24 07:12:00Z]
    end

    test "update_transaction/2 with invalid data returns error changeset" do
      transaction = transaction_fixture()
      assert {:error, %Ecto.Changeset{}} = Statistic.update_transaction(transaction, @invalid_attrs)
      assert transaction == Statistic.get_transaction!(transaction.id)
    end

    test "delete_transaction/1 deletes the transaction" do
      transaction = transaction_fixture()
      assert {:ok, %Transaction{}} = Statistic.delete_transaction(transaction)
      assert_raise Ecto.NoResultsError, fn -> Statistic.get_transaction!(transaction.id) end
    end

    test "change_transaction/1 returns a transaction changeset" do
      transaction = transaction_fixture()
      assert %Ecto.Changeset{} = Statistic.change_transaction(transaction)
    end
  end
end
