defmodule QuizzicalWeb.CategoryLive.Show do
  use QuizzicalWeb, :live_view

  alias Quizzical.Categories
  alias Quizzical.Questions

  @impl true
  def mount(_params, session, socket) do
    {:ok,
     socket
     |> assign_defaults(session)}
  end

  @impl true
  def handle_params(%{"slug" => slug} = params, _session, socket) do
    category = Categories.get_category_by_slug!(slug)
    page = String.to_integer(params["page"] || "1")
    paginate_options = %{page: page, per_page: 5}

    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:category, category)
     |> assign(:options, paginate_options)
     |> assign(:questions, Questions.list_by_category_id(category.id, paginate_options))}
  end

  defp page_title(:show), do: "Show Category"
  defp page_title(:edit), do: "Edit Category"
end
