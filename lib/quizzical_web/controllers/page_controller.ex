defmodule QuizzicalWeb.PageController do
  use QuizzicalWeb, :controller

  def attribution(conn, _params) do
    render(conn, "attribution.html")
  end

  def privacy(conn, _params) do
    render(conn, "privacy.html")
  end
end
