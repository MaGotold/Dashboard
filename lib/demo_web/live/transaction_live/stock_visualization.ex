defmodule DemoWeb.StockVisualizationLive do
  use Phoenix.LiveComponent
  alias Demo.Statistic

  def render(assigns) do
    
    ~L"""
    <div>
      <h2>Stock Overview</h2>
      <p>Total stock in all products: <%= @total_stock %></p>
    </div>
    """
  end

  def update(_params, socket) do
    total_stock = Statistic.get_total_stock()  # Fetch the total stock from your Statistic context
    {:ok, assign(socket, total_stock: total_stock)}
  end
end
