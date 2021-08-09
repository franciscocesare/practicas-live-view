defmodule TwitterClon.Counters do
  @moduledoc """
  The Counters context.
  """

  import Ecto.Query, warn: false
  alias TwitterClon.Repo

  alias TwitterClon.Counters.Count

  @doc """
  Returns the list of counters.

  ## Examples

      iex> list_counters()
      [%Count{}, ...]

  """
  def list_counters do
    Repo.all(Count)
    |> Enum.sort_by(& &1.name_counter, :asc)
    #|> IO.inspect()
  end

  @doc """
  Gets a single count.

  Raises `Ecto.NoResultsError` if the Count does not exist.

  ## Examples

      iex> get_count!(123)
      %Count{}

      iex> get_count!(456)
      ** (Ecto.NoResultsError)

  """
  def get_count!(id), do: Repo.get!(Count, id)

  @doc """
  Creates a count.

  ## Examples

      iex> create_count(%{field: value})
      {:ok, %Count{}}

      iex> create_count(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_count(attrs \\ %{}) do
    %Count{}
    |> Count.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a count.

  ## Examples

      iex> update_count(count, %{field: new_value})
      {:ok, %Count{}}

      iex> update_count(count, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_count(%Count{} = count, attrs) do
    count
    |> Count.changeset(attrs)
    |> Repo.update()
  end
  

  @doc """
  Deletes a count.

  ## Examples

      iex> delete_count(count)
      {:ok, %Count{}}

      iex> delete_count(count)
      {:error, %Ecto.Changeset{}}

  """
  def delete_count(%Count{} = count) do
    Repo.delete(count)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking count changes.

  ## Examples

      iex> change_count(count)
      %Ecto.Changeset{data: %Count{}}

  """
  def change_count(%Count{} = count, attrs \\ %{}) do
    Count.changeset(count, attrs)
  end
end
