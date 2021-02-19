defmodule Quizzical.Repo.Migrations.AddHiddenQuestionsForUsers do
  use Ecto.Migration

  def change do
    create table(:hidden_questions, primary_key: false) do
      add :question_id, references(:questions, on_delete: :delete_all)
      add :user_id, references(:users, on_delete: :delete_all)
    end
  end
end
