defmodule Quizzical.Repo.Migrations.RemoveQuestionCount do
  use Ecto.Migration

  def change do
    alter table(:categories) do
      remove(:question_count)
    end
  end
end
