defmodule Quizzical.Categories.Category do
  use Ecto.Schema
  import Ecto.Changeset

  alias Quizzical.Questions.Question

  schema "categories" do
    field :name, :string
    field :slug, :string
    many_to_many :questions, Question, join_through: "questions_categories"
  end

  @doc false
  def changeset(category, attrs) do
    category
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> slugify_name()
  end

  defp slugify_name(changeset) do
    case fetch_change(changeset, :name) do
      {:ok, new_name} -> put_change(changeset, :slug, slugify(new_name))
      :error -> changeset
    end
  end

  def slugify(str) do
    str
    |> String.downcase()
    |> String.replace(~r/[^\w-]+/u, "-")
  end
end
