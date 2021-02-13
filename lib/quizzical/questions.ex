defmodule Quizzical.Questions do
  @moduledoc """
  The Questions context.
  """

  import Ecto.Query, warn: false
  import Ecto.Changeset
  alias Quizzical.Repo
  alias Quizzical.Categories.Category
  alias Quizzical.Questions.Question

  @doc """
  Returns the list of questions.

  ## Examples

      iex> list_questions()
      [%Question{}, ...]

  """
  def list_questions do
    Repo.all(Question) |> Repo.preload(:categories)
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
    # IO.inspect(get_category_names(attrs["categories"])

    %Question{}
    |> Question.changeset(attrs)
    |> update_parent_count(1)
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
    |> update_parent_count(-1)
    |> Repo.delete!()
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

  defp update_parent_count(changeset, value) do
    changeset
    |> prepare_changes(fn changeset ->
      if category_id = get_field(changeset, :category_id) do
        query = from Category, where: [id: ^category_id]
        changeset.repo.update_all(query, inc: [question_count: value])
      end

      changeset
    end)
  end
end
