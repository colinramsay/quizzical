defmodule QuizzicalWeb.CategoryLive.Show do
  use QuizzicalWeb, :live_view

  alias Quizzical.Categories

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"slug" => slug}, _, socket) do
    category = Categories.get_category_by_slug!(slug)
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:category, category)
     |> assign(:questions, category.questions)}
  end

  defp page_title(:show), do: "Show Category"
  defp page_title(:edit), do: "Edit Category"
end
