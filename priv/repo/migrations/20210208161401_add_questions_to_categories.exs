defmodule Quizzical.Repo.Migrations.AddQuestionsToCategories do
  use Ecto.Migration

  def change do
    create table(:questions_categories, primary_key: false) do
      add :question_id, references(:questions, on_delete: :delete_all)
      add :category_id, references(:categories, on_delete: :delete_all)
    end
  end
end
