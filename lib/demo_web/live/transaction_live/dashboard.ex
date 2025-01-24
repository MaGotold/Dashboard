defmodule DemoWeb.DashboardLive.Dashboard do
  use DemoWeb, :live_view

  alias Demo.Statistic

  def mount(params, _session, socket) do

    today = Date.utc_today()

    year = Map.get(params, "year", today.year) |> to_string()
    month = Map.get(params, "month", today.month) |> to_string()

    total_stock = Statistic.get_total_stock()
    best_selling_products = Statistic.get_best_selling_products()
    years_and_months = Statistic.get_available_years_and_months()


    years = Enum.map(years_and_months, fn {year, _months} -> year end)
    months =
      years_and_months
      |> Enum.filter(fn {y, _} -> Decimal.equal?(y, Decimal.new(year)) end) # Compare Decimal year
      |> Enum.flat_map(fn {_y, months} -> Enum.map(months, &Decimal.to_integer/1) end) # Convert months to integers

    {product_sales, total_quantity} = Statistic.get_product_sales_by_month(String.to_integer(year), String.to_integer(month))

    #IO.inspect(years, label: "Available Years")
    #IO.inspect(months, label: "Available Months for Selected Year")
    #IO.inspect(years_and_months, label: "Available Months for Selected Year")

    socket =
      assign(socket, %{
        total_stock: total_stock || 0,
        best_selling_products: best_selling_products || [],
        product_sales: product_sales || [],
        total_quantity: total_quantity || 0,
        year: year,
        month: month,
        years: years,
        months: months
      })

    {:ok, socket}
  end

  def handle_event("filter", %{"year" => year, "month" => month}, socket) do

    year = String.to_integer(year)
    month = String.to_integer(month)

    {product_sales, total_quantity} = Statistic.get_product_sales_by_month(year, month)

    years_and_months = Statistic.get_available_years_and_months()

    years = Enum.map(years_and_months, fn {year, _months} -> year end)
    months = Enum.flat_map(years_and_months, fn {_year, months} -> months end)

    socket = assign(socket, %{
      product_sales: product_sales,
      total_quantity: total_quantity,
      year: year,
      month: month,
      years: years,
      months: months
    })

    {:noreply, socket}
  end
end
