defmodule TwitterClon.ListWordsTest do
  use TwitterClon.DataCase

  alias TwitterClon.ListWords

  describe "words" do
    alias TwitterClon.ListWords.Word

    @valid_attrs %{new_word: "some new_word"}
    @update_attrs %{new_word: "some updated new_word"}
    @invalid_attrs %{new_word: nil}

    def word_fixture(attrs \\ %{}) do
      {:ok, word} =
        attrs
        |> Enum.into(@valid_attrs)
        |> ListWords.create_word()

      word
    end

    test "list_words/0 returns all words" do
      word = word_fixture()
      assert ListWords.list_words() == [word]
    end

    test "get_word!/1 returns the word with given id" do
      word = word_fixture()
      assert ListWords.get_word!(word.id) == word
    end

    test "create_word/1 with valid data creates a word" do
      assert {:ok, %Word{} = word} = ListWords.create_word(@valid_attrs)
      assert word.new_word == "some new_word"
    end

    test "create_word/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = ListWords.create_word(@invalid_attrs)
    end

    test "update_word/2 with valid data updates the word" do
      word = word_fixture()
      assert {:ok, %Word{} = word} = ListWords.update_word(word, @update_attrs)
      assert word.new_word == "some updated new_word"
    end

    test "update_word/2 with invalid data returns error changeset" do
      word = word_fixture()
      assert {:error, %Ecto.Changeset{}} = ListWords.update_word(word, @invalid_attrs)
      assert word == ListWords.get_word!(word.id)
    end

    test "delete_word/1 deletes the word" do
      word = word_fixture()
      assert {:ok, %Word{}} = ListWords.delete_word(word)
      assert_raise Ecto.NoResultsError, fn -> ListWords.get_word!(word.id) end
    end

    test "change_word/1 returns a word changeset" do
      word = word_fixture()
      assert %Ecto.Changeset{} = ListWords.change_word(word)
    end
  end
end
