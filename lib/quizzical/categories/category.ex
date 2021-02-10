defmodule Quizzical.Categories.Category do
  use Ecto.Schema
  import Ecto.Changeset

  schema "categories" do
    field :name, :string
    field :slug, :string
    field :question_count, :integer, default: 0
    has_many :questions, Quizzical.Questions.Question
    timestamps()
  end

  @doc false
  def changeset(category, attrs) do
    category
    |> cast(attrs, [:name, :question_count])
    |> validate_required([:name])
    |> slugify_name()
  end


  defp slugify_name(changeset) do
   case fetch_change(changeset, :name) do
    {:ok, new_name}-> put_change(changeset,:slug, slugify(new_name))
    :error-> changeset
   end
  end

  defp slugify(str) do
    str
    |> String.downcase()
    |> String.replace(~r/[^\w-]+/u,"-")
  end
end
