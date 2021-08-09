defmodule TwitterClon.Counters.Count do
  use Ecto.Schema
  import Ecto.Changeset

  schema "counters" do
    field :initial_count, :integer, default: 0
    field :name_counter, :string

    timestamps()
  end

  @doc false
  def changeset(count, attrs) do
    count
    |> cast(attrs, [:name_counter, :initial_count])
    |> validate_required([:name_counter, :initial_count])
  end
end
