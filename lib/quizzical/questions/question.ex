defmodule Quizzical.Questions.Question do
  use Ecto.Schema
  import Ecto.Changeset

  alias Quizzical.Categories.Category

  schema "questions" do
    field :question, :string
    field :answer, :string
    belongs_to :category, Category

    timestamps()
  end

  @doc false
  def changeset(question, attrs) do
    question
    |> cast(attrs, [:question, :answer, :category_id])
    |> validate_required([:question, :answer, :category_id])
  end
end
