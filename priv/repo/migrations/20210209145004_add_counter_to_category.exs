defmodule Quizzical.Repo.Migrations.AddCounterToCategory do
  use Ecto.Migration

  def change do
    alter table("categories") do
      add :question_count, :integer
    end
  end
end
