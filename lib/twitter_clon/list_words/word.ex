defmodule TwitterClon.ListWords.Word do
  use Ecto.Schema
  import Ecto.Changeset

  schema "words" do
    field :new_word, :string

    timestamps()
  end

  @doc false
  def changeset(word, attrs) do
    word
    |> cast(attrs, [:new_word])
    |> validate_required([:new_word])
    |> validate_length(:new_word, min: 3)
  end
end
