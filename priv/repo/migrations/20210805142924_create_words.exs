defmodule TwitterClon.Repo.Migrations.CreateWords do
  use Ecto.Migration

  def change do
    create table(:words) do
      add :new_word, :string

      timestamps()
    end

  end
end
