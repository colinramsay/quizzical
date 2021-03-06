defmodule QuizzicalWeb.CategoryLive.Index do
  use QuizzicalWeb, :live_view

  alias Quizzical.Categories
  alias Quizzical.Categories.Category

  @impl true
  def mount(_params, session, socket) do
    {:ok,
     socket
     |> assign(:categories, list_categories())
     |> assign_defaults(session)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"slug" => slug}) do
    socket
    |> assign(:page_title, "Edit Category")
    |> assign(:category, Categories.get_category_by_slug!(slug))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Category")
    |> assign(:category, %Category{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Categories")
    |> assign(:category, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    category = Categories.get_category!(id)
    {:ok, _} = Categories.delete_category(category)

    {:noreply, assign(socket, :categories, list_categories())}
  end

  defp list_categories do
    Categories.list_categories()
  end
end
