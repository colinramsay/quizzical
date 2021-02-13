defmodule Quizzical.Repo.Migrations.AddCategoryNameIndex do
  use Ecto.Migration

  def change do
    alter table(:categories) do
      remove :inserted_at
      remove :updated_at
    end

    create index(:categories, [:name])
  end
end
