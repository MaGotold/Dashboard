defmodule DemoWeb.ProductLive.Index do
  use DemoWeb, :live_view

  alias Demo.Products
  alias Demo.Products.Product
  alias DemoWeb.Router.Helpers, as: Routes


  def mount(params, _session, socket) do
    IO.puts("Mounting ProductLive.Index")

    user_id = socket.assigns.current_user.id

    # Get the category filter from params
    filters = %{
      category: params["category"]
    }

    IO.inspect(filters, label: "Filters in mount")


    products = Products.list_products(user_id, filters)

    socket = assign(socket, :products, products)
    {:ok, socket}
  end


  @impl true
  def handle_event("delete_product", %{"id" => product_id}, socket) do
    case Products.get_product!(product_id) do
      nil ->
        {:noreply, socket}

      %Product{} = product ->
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

  @impl true
  def handle_event("filter_products", %{"category" => category}, socket) do
  IO.inspect(category, label: "Category Selected")

  user_id = socket.assigns.current_user.id

  # Apply the category filter
  filters = %{
    category: category
  }

  products = Products.list_products(user_id, filters)

  {:noreply, assign(socket, :products, products)}
end


end
