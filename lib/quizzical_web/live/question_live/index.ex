defmodule QuizzicalWeb.QuestionLive.Index do
  use QuizzicalWeb, :live_view

  alias Quizzical.Categories
  alias Quizzical.Questions

  @impl true
  def mount(_params, session, socket) do
    {
      :ok,
      socket
      |> assign_defaults(session)
    }
  end

  @impl true
  @spec handle_params(any, any, Phoenix.LiveView.Socket.t()) ::
          {:noreply, Phoenix.LiveView.Socket.t()}
  def handle_params(params, _url, socket) do
    page = String.to_integer(params["page"] || "1")
    paginate_options = %{page: page, per_page: 5}
    question_page = Quizzical.Questions.list_questions(paginate_options)

    socket = assign(socket, options: paginate_options, question_page: question_page)

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

  defp apply_action(socket, :index, params) do
    socket
    |> assign(:page_title, "Listing Questions")
    |> assign(:question, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    question = Questions.get_question!(id)
    {:ok, _} = Questions.delete_question(question)

    {:noreply,
     assign(socket, :questions, Quizzical.Questions.list_questions())
     |> put_flash(:info, "Question deleted")}
  end

  defp question_page_info(
         %{options: %{page: page, per_page: per_page}, question_page: %{total: total}} = assigns
       ) do
    from = per_page * (page - 1) + 1
    to = per_page * (page - 1) + per_page
    fto = if to > total, do: total, else: to

    ~L"""
      <p class="totaliser">
        Showing questions <%= from %> to <%= fto  %> of <%= total %>
      </p>
    """
  end
end
