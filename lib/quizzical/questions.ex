defmodule Quizzical.Questions do
  @moduledoc """
  The Questions context.
  """

  import Ecto.Query, warn: false
  alias Quizzical.Repo
  alias Quizzical.Questions.Question

  def hide_question(question, user) do
    user
    |> Repo.preload(:hidden_questions)
    |> Ecto.Changeset.change()
    |> Ecto.Changeset.put_assoc(:hidden_questions, [question])
    |> Repo.update!()
  end

  @doc """
  ### Examples
  iex> create_questions([%{"question": "q", "answer": "a", "categories": ["cat1", "cat2"]},%{...}])
  """
  def create_questions(questions_attrs) do
    questions_attrs
    |> Enum.with_index()
    |> Enum.reduce(Ecto.Multi.new(), fn {attrs, idx}, multi ->
      question_changeset =
        %Question{}
        |> Question.changeset(attrs)

      Ecto.Multi.insert(multi, {:question, idx}, question_changeset)
    end)
    |> Repo.transaction()
  end

  @doc """
  Returns the list of questions.

  ## Examples

      iex> list_questions()
      [%Question{}, ...]

  """
  def list_questions(paginate_options \\ %{page: 1, per_page: 100}) do
    query = from q in Question, preload: :categories
    Repo.paginate(query, paginate_options)
  end

  def list_by_category_id(id, paginate_options) do
    query =
      from q in Question,
        join: qc in "questions_categories",
        on: qc.question_id == q.id,
        where: qc.category_id == ^id,
        preload: [:categories]

    Repo.paginate(query, paginate_options)
  end

  def new_question do
    %Question{} |> Repo.preload(:categories)
  end

  @doc """
  Gets a single question.

  Raises `Ecto.NoResultsError` if the Question does not exist.

  ## Examples

      iex> get_question!(123)
      %Question{}

      iex> get_question!(456)
      ** (Ecto.NoResultsError)

  """
  def get_question!(id) do
    Repo.get!(Question, id) |> Repo.preload(:categories)
  end

  @doc """
  Creates a question.

  ## Examples

      iex> create_question(%{field: value})
      {:ok, %Question{}}

      iex> create_question(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_question(attrs \\ %{}) do
    %Question{}
    |> Question.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a question.

  ## Examples

      iex> update_question(question, %{field: new_value})
      {:ok, %Question{}}

      iex> update_question(question, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_question(%Question{} = question, attrs) do
    question
    |> Question.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a question.

  ## Examples

      iex> delete_question(question)
      {:ok, %Question{}}

      iex> delete_question(question)
      {:error, %Ecto.Changeset{}}

  """
  def delete_question(%Question{} = question) do
    Question.changeset(question, %{})
    |> Repo.delete()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking question changes.

  ## Examples

      iex> change_question(question)
      %Ecto.Changeset{data: %Question{}}

  """
  def change_question(%Question{} = question, attrs \\ %{}) do
    Question.changeset(question, attrs)
  end

  def random() do
    query =
      from Question,
        order_by: fragment("RANDOM()"),
        limit: 1

    Repo.one(query)
  end

  def not_hidden(user) do
    sq = from hq in "hidden_questions", where: hq.user_id == ^user.id, select: hq.question_id

    query =
      from q in Question,
        where: not (q.id in subquery(sq))

    Repo.all(query)

    # select * from questions q where not q.id in (select question_id from hidden_questions hq where user_id = 1)
  end

  def hidden(user) do
    sq = from hq in "hidden_questions", where: hq.user_id == ^user.id, select: hq.question_id

    query =
      from q in Question,
        where: q.id in subquery(sq)

    Repo.all(query)
  end
end
