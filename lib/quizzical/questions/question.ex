defmodule Quizzical.Questions.Question do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  alias Quizzical.Categories.Category
  alias Quizzical.Repo

  schema "questions" do
    field :question, :string
    field :answer, :string
    many_to_many :categories, Category, join_through: "questions_categories", on_replace: :delete

    timestamps()
  end

  @doc false
  def changeset(question, attrs) do
    categories = attrs["categories"] || []

    question
    |> cast(attrs, [:question, :answer])
    |> validate_required([:question, :answer])
    |> Ecto.Changeset.put_assoc(:categories, insert_and_get_all_categories(categories))
  end

  # defp insert_and_get_all_categories([]) do
  #   []
  # end

  defp insert_and_get_all_categories(names) do
    # Convert the array of category names into an array of { name: "name" } maps
    maps = Enum.map(names, &%{name: &1})

    # Insert all of those categories into the database, if theres's a naming conflict
    # just ignore it. That means we can insert all the categories each time and not care about duplicates.
    Repo.insert_all(Category, maps, on_conflict: :nothing)

    # Now return full categories objects matching the passed-in names, because `put_assoc` expects
    # category objects.
    Repo.all(from c in Category, where: c.name in ^names)
  end
end
