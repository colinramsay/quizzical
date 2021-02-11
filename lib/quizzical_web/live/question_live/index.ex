defmodule QuizzicalWeb.QuestionLive.Index do
  use QuizzicalWeb, :live_view

  alias Quizzical.Categories
  alias Quizzical.Questions

  @impl true
  def mount(_params, session, socket) do
    {
      :ok,
      socket
      |> assign(:questions, list_questions())
      |> assign_defaults(session)
    }
  end

  # def mount(_params, _session, socket) do
  #   {
  #     :ok,
  #     assign(socket, %{questions: list_questions(), current_user: nil})
  #   }
  # end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Question")
    |> assign(:question, Questions.get_question!(id))
    |> assign(:categories, Categories.list_categories())
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Question")
    |> assign(:categories, Categories.list_categories())
    |> assign(:question, Questions.new_question())
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Questions")
    |> assign(:question, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    question = Questions.get_question!(id)
    {:ok, _} = Questions.delete_question(question)

    {:noreply,
     assign(socket, :questions, list_questions()) |> put_flash(:info, "Question deleted")}
  end

  defp list_questions do
    Questions.list_questions()
  end
end
