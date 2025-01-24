defmodule DemoWeb.DashboardLive.Dashboard do
  use DemoWeb, :live_view

  alias Demo.Statistic

  def mount(params, _session, socket) do
    # Get the current user from socket assign
    user_id = socket.assigns.current_user.id

    # Get the total stock and best-selling products similar to how you did in the previous example
    total_stock = Statistic.get_total_stock()
    best_selling_products = Statistic.get_best_selling_products()

    year = Map.get(params, "year", Date.utc_today().year)
    month = Map.get(params, "month", Date.utc_today().month)
    {product_sales, total_quantity} = Statistic.get_product_sales_by_month(year, month)

    IO.inspect(month, label: "month")
    IO.inspect({product_sales, total_quantity}, label: "Product Sales and Total Quantity")
    IO.inspect(best_selling_products, label: "this")

    # Assign data to the socket
    socket = assign(socket, %{
      total_stock: total_stock,
      best_selling_products: best_selling_products
    })

    {:ok, socket}
  end
end
