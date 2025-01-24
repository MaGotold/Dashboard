# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Demo.Repo.insert!(%Demo.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Demo.Repo
alias Demo.Products.Product
alias Demo.Statistic.Transaction
alias Demo.Users.User

defmodule Seeds do
  def insert_random_products do
    # Ensure that there's a user in the database
    insert_user()

    products = [
      %{photo: "tshirt_blue.jpg", title: "Blue T-shirt", description: "A casual blue t-shirt for everyday wear", category: "Clothing", price: 25.99, stock: 150, user_id: 1},
      %{photo: "graphic_tee.jpg", title: "Graphic Tee", description: "A graphic t-shirt with a trendy design", category: "Clothing", price: 29.99, stock: 200, user_id: 1},
      %{photo: "denim_jacket.jpg", title: "Denim Jacket", description: "A classic blue denim jacket, perfect for cool weather", category: "Jackets", price: 49.99, stock: 50, user_id: 1},
      %{photo: "leather_jacket.jpg", title: "Leather Jacket", description: "A stylish black leather jacket for a sleek look", category: "Jackets", price: 99.99, stock: 30, user_id: 1},
      %{photo: "vintage_jeans.jpg", title: "Vintage Jeans", description: "A pair of vintage wash jeans with a relaxed fit", category: "Trousers", price: 39.99, stock: 120, user_id: 1},
      %{photo: "chinos.jpg", title: "Chino Pants", description: "Comfortable and stylish chino pants for any occasion", category: "Trousers", price: 35.99, stock: 180, user_id: 1},
      %{photo: "cozy_sweater.jpg", title: "Cozy Sweater", description: "A warm and soft sweater for chilly days", category: "Sweaters", price: 45.99, stock: 75, user_id: 1},
      %{photo: "wool_scarf.jpg", title: "Wool Scarf", description: "A soft wool scarf to keep you warm in winter", category: "Accessories", price: 19.99, stock: 100, user_id: 1},
      %{photo: "beanie_hat.jpg", title: "Beanie Hat", description: "A cozy beanie hat to complete your cold weather look", category: "Accessories", price: 15.99, stock: 200, user_id: 1},
      %{photo: "running_shoes.jpg", title: "Running Shoes", description: "Lightweight running shoes for maximum comfort", category: "Footwear", price: 59.99, stock: 50, user_id: 1}
    ]

    Enum.each(products, fn product_attrs ->
      %Product{}
      |> Product.changeset(product_attrs)
      |> Repo.insert!()
    end)
  end

  def insert_user do
    case Repo.get(User, 1) do
      nil ->
        %Demo.Users.User{}
        |> User.registration_changeset(%{email: "testuser@example.com", password: "password1234!"})
        |> Repo.insert!()

      _user ->
        IO.puts("User already exists")
    end

    case Repo.get(User, 2) do
      nil ->
        %Demo.Users.User{}
        |> User.registration_changeset(%{email: "seconduser@example.com", password: "password1234!"})
        |> Repo.insert!()

      _user ->
        IO.puts("Second user already exists")
    end
  end

  def insert_random_transactions do
    # Get all the products from the database
    products = Repo.all(Product)

    transactions = [
      %{product_id: 2, quantity: 2, transaction_date: ~U[2025-01-01 10:30:00Z]},
      %{product_id: 3, quantity: 1, transaction_date: ~U[2025-01-02 14:00:00Z]},
      %{product_id: 4, quantity: 1, transaction_date: ~U[2025-01-03 09:15:00Z]},
      %{product_id: 5, quantity: 1, transaction_date: ~U[2025-02-04 11:45:00Z]},
      %{product_id: 6, quantity: 3, transaction_date: ~U[2025-02-05 08:00:00Z]},
      %{product_id: 7, quantity: 2, transaction_date: ~U[2025-02-06 17:30:00Z]},
      %{product_id: 8, quantity: 1, transaction_date: ~U[2025-03-07 12:00:00Z]},
      %{product_id: 9, quantity: 5, transaction_date: ~U[2025-03-08 16:20:00Z]},
      %{product_id: 10, quantity: 10, transaction_date: ~U[2025-02-09 19:00:00Z]},
      %{product_id: 11, quantity: 1, transaction_date: ~U[2025-01-10 13:45:00Z]}
    ]

    Enum.each(transactions, fn %{product_id: product_id, quantity: quantity, transaction_date: transaction_date} ->
      # Find the product price based on the product_id
      product = Enum.find(products, fn p -> p.id == product_id end)

      # Ensure the product price is available
      if product do
        total_price = Decimal.new(product.price) |> Decimal.mult(Decimal.new(quantity))

        %Transaction{}
        |> Transaction.changeset(%{product_id: product_id, quantity: quantity, total_price: total_price, transaction_date: transaction_date})
        |> Repo.insert!()
      else
        IO.puts("Product with id #{product_id} not found")
      end
    end)
  end

  def reset_tables do
    # Delete all records from the products and transactions tables
    Repo.delete_all(Product)
    Repo.delete_all(Transaction)

    # Reset the primary key sequences (for PostgreSQL)
    Repo.query!("ALTER SEQUENCE products_id_seq RESTART WITH 1")
    Repo.query!("ALTER SEQUENCE transactions_id_seq RESTART WITH 1")
  end
end

#Seeds.reset_tables()
Seeds.insert_random_products()
Seeds.insert_random_transactions()
