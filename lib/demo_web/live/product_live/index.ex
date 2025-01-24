defmodule DemoWeb.ProductLive.Index do
  use DemoWeb, :live_view

  alias Demo.Products
  alias Demo.Products.Product
  alias DemoWeb.Router.Helpers, as: Routes


  def mount(params, _session, socket) do
    IO.puts("Mounting ProductLive.Index")

    user_id = socket.assigns.current_user.id

    # Get category and price_sort filters from params (with defaults)
    category = params["category"] || ""
    price_sort = params["price_sort"] || ""

    # Combine filters into a map
    filters = %{
      category: category,
      price_sort: price_sort
    }

    IO.inspect(filters, label: "Filters in mount")

    # Fetch the products based on the filters
    products = Products.list_products(user_id, filters)

    # Use assign/3 to update socket with products and filters
    socket = assign(socket, :products, products)
    socket = assign(socket, :selected_category, category)
    socket = assign(socket, :selected_price_sort, price_sort)

    {:ok, socket}
  end


  @impl true
  def handle_event("delete_product", %{"id" => product_id}, socket) do
    IO.puts("Trying to delete product with ID: #{product_id}")

    case Products.get_product!(product_id) do
      nil ->
        {:noreply, socket}

      %Product{} = product ->
        IO.puts("Deleting product with ID: #{product.id}")  # Log after the product is fetched

        # Call your delete_product function here
        Products.delete_product(product)

        # Remove the product from the list in the socket state
        products = Products.list_products()
        {:noreply, assign(socket, :products, products)}
    end
  end

  @impl true
  def handle_event("edit_product", %{"id" => id}, socket) do
    IO.inspect(id, label: "Product ID received")

    product = Products.get_product!(id)
    #path = Routes.product_edit_path(socket, :edit, id)

    # This will trigger a redirect to the edit page, and pass the product's ID in the URL
    {:noreply, push_navigate(socket, to: "/products/#{product.id}/edit")}
  end

  def handle_event("filter_products", %{"category" => category, "price_sort" => price_sort}, socket) do
    IO.inspect(category, label: "Category Selected")
    IO.inspect(price_sort, label: "Price Sort Selected")

    user_id = socket.assigns.current_user.id

    # Create the filters map with the updated category and price_sort
    filters = %{
      category: category,
      price_sort: price_sort
    }

    # Get products based on filters (category and price_sort)
    products = Products.list_products(user_id, filters)

    # Use assign/3 to update the socket
    socket = assign(socket, :products, products)
    socket = assign(socket, :selected_category, category)
    socket = assign(socket, :selected_price_sort, price_sort)

    {:noreply, socket}
  end


end
