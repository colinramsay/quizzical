defmodule Quizzical.Repo.Migrations.RemoveCategoryQuestionJoin do
  use Ecto.Migration

  def change do
    drop table("questions_categories")

    alter table("questions") do
      add :category_id, references("categories")
    end
  end
end
