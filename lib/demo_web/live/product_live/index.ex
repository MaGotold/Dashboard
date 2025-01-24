defmodule DemoWeb.ProductLive.Index do
  use DemoWeb, :live_view

  alias Demo.Products
  alias Demo.Products.Product
  alias DemoWeb.Router.Helpers, as: Routes

  @impl true
  def mount(params, _session, socket) do
    IO.puts("Mounting ProductLive.Index")

    user_id = socket.assigns.current_user.id

    category = params["category"] || ""
    price_sort = params["price_sort"] || ""

    filters = %{
      category: category,
      price_sort: price_sort
    }

    IO.inspect(filters, label: "Filters in mount")

    products = Products.list_products(filters)

    if connected?(socket) do
      Phoenix.PubSub.subscribe(Demo.PubSub, "product_feed")
    end

    socket = assign(socket, :products, products)
    socket = assign(socket, :selected_category, category)
    socket = assign(socket, :selected_price_sort, price_sort)

    {:ok, socket}
  end

  @impl true
  def handle_info({:new_product, product}, socket) do
    products = [product | socket.assigns.products]
    {:noreply, assign(socket, :products, products)}
  end

  @impl true
  def handle_event("edit_product", %{"id" => id}, socket) do
    product_id = String.to_integer(id)
    product = Products.get_product!(product_id)

  {:noreply, push_navigate(socket, to: ~p"/products/#{product.id}/edit")}
  end

  def handle_event("delete_product", %{"id" => id}, socket) do
    product = Enum.find(socket.assigns.products, fn p -> p.id == String.to_integer(id) end)

    if product do
      case Demo.Products.delete_product(product) do
        {:ok, _product} ->
          products = Enum.reject(socket.assigns.products, fn p -> p.id == product.id end)
          {:noreply, assign(socket, :products, products)}

        {:error, :not_found} ->
          {:noreply, socket}
      end
    else
      {:noreply, socket}
    end
  end

  def handle_event("filter_products", %{"category" => category, "price_sort" => price_sort}, socket) do
    # Reset category to empty string if "All Categories" is selected, otherwise keep the selected category
    selected_category =
      case category do
        "" -> ""  # Reset to "All Categories" when the empty value is selected
        _ -> category  # Keep the selected category if one is chosen
      end

    # Only update price_sort if it's explicitly set, else keep the current value
    selected_price_sort =
      if price_sort != "", do: price_sort, else: socket.assigns.selected_price_sort

    filters = %{
      category: selected_category,
      price_sort: selected_price_sort
    }

    products = Products.list_products(filters)

    socket = assign(socket, :products, products)
    socket = assign(socket, :selected_category, selected_category)
    socket = assign(socket, :selected_price_sort, selected_price_sort)

    {:noreply, socket}
  end
  
end
