defmodule Quizzical.Questions.Question do
  use Ecto.Schema
  import Ecto.Changeset

  alias Quizzical.Categories.Category

  schema "questions" do
    field :question, :string
    belongs_to :category, Category

    timestamps()
  end

  @doc false
  def changeset(question, attrs) do
    question
    |> cast(attrs, [:question, :category_id])
    |> validate_required([:question, :category_id])
  end
end
