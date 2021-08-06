defmodule TwitterClon.Repo.Migrations.CreateCounters do
  use Ecto.Migration

  def change do
    create table(:counters) do
      add :name_counter, :string
      add :initial_count, :integer

      timestamps()
    end

  end
end
