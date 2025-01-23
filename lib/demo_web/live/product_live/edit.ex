defmodule DemoWeb.ProductLive.Edit do
  use DemoWeb, :live_view

  alias Demo.Products

  @impl true
  def mount(%{"id" => product_id}, _session, socket) do
    product = Products.get_product!(product_id)
    changeset = Products.Product.changeset(product)
    IO.inspect(changeset, label: "Initial Changeset")


    socket =
      socket
      |> assign(:product, product)
      |> assign(:form, to_form(changeset))

    {:ok, socket}
  end

  @impl true
  def handle_event("submit", %{"product" => product_params}, socket) do
    product = socket.assigns.product

    case Products.update_product(product, product_params) do
      {:ok, _updated_product} ->
        socket =
          socket
          |> put_flash(:info, "Product updated successfully.")
          |> push_navigate(to: ~p"/products")

        {:noreply, socket}

      {:error, changeset} ->
        socket = assign(socket, :form, to_form(changeset))
        {:noreply, socket}
    end
  end

  @impl true
  def handle_event("cancel", _, socket) do
    socket =
      socket
      |> push_navigate(to: ~p"/products")

    {:noreply, socket}
  end
end
