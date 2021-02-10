defmodule Quizzical.Repo.Migrations.AddSlugToCategory do
  use Ecto.Migration

  def change do
    alter table("categories") do
      add :slug, :string
    end
  end
end
