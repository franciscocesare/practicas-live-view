defmodule TwitterClon.CountersTest do
  use TwitterClon.DataCase

  alias TwitterClon.Counters

  describe "counters" do
    alias TwitterClon.Counters.Count

    @valid_attrs %{initial_count: 42, name_counter: "some name_counter"}
    @update_attrs %{initial_count: 43, name_counter: "some updated name_counter"}
    @invalid_attrs %{initial_count: nil, name_counter: nil}

    def count_fixture(attrs \\ %{}) do
      {:ok, count} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Counters.create_count()

      count
    end

    test "list_counters/0 returns all counters" do
      count = count_fixture()
      assert Counters.list_counters() == [count]
    end

    test "get_count!/1 returns the count with given id" do
      count = count_fixture()
      assert Counters.get_count!(count.id) == count
    end

    test "create_count/1 with valid data creates a count" do
      assert {:ok, %Count{} = count} = Counters.create_count(@valid_attrs)
      assert count.initial_count == 42
      assert count.name_counter == "some name_counter"
    end

    test "create_count/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Counters.create_count(@invalid_attrs)
    end

    test "update_count/2 with valid data updates the count" do
      count = count_fixture()
      assert {:ok, %Count{} = count} = Counters.update_count(count, @update_attrs)
      assert count.initial_count == 43
      assert count.name_counter == "some updated name_counter"
    end

    test "update_count/2 with invalid data returns error changeset" do
      count = count_fixture()
      assert {:error, %Ecto.Changeset{}} = Counters.update_count(count, @invalid_attrs)
      assert count == Counters.get_count!(count.id)
    end

    test "delete_count/1 deletes the count" do
      count = count_fixture()
      assert {:ok, %Count{}} = Counters.delete_count(count)
      assert_raise Ecto.NoResultsError, fn -> Counters.get_count!(count.id) end
    end

    test "change_count/1 returns a count changeset" do
      count = count_fixture()
      assert %Ecto.Changeset{} = Counters.change_count(count)
    end
  end
end
