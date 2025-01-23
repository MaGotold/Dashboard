defmodule DemoWeb.ProductLive.New do
  use DemoWeb, :live_view

  alias Demo.Products

  def mount(_params, _session, socket) do
    changeset = Products.Product.changeset(%Products.Product{})
    socket = assign(socket, :form, to_form(changeset))
    {:ok, socket}
  end

def handle_event("submit", %{"product" => product_params}, socket) do
    # Ensure that user_id is added to the params
    product_params = Map.put(product_params, "user_id", socket.assigns.current_user.id)



    IO.inspect(product_params, label: "Product Params")

    case Products.create_product(product_params) do

      {:ok, _product} ->
        socket =
          socket
          |> put_flash(:info, "Product added successfully.")
          |> push_navigate(to: "/products")

        {:noreply, socket}

      {:error, changeset} ->
        socket = assign(socket, :form, to_form(changeset))
        {:noreply, socket}
    end
  end

end
