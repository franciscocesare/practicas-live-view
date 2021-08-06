defmodule TwitterClonWeb.PageLive do
  use TwitterClonWeb, :live_view

  alias TwitterClon.ListWords
  alias TwitterClon.ListWords.Word

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     assign(socket,
       counters: gen_counters(1),
       page_title: "New Word",
       word: %Word{},
       words: list_words()
     )}
  end

  # Events
  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  def handle_event("create", _params, socket) do
    {:noreply, assign(socket, counters: add_counters(socket.assigns.counters))}
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Word")
    |> assign(:word, %Word{})
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Word")
    |> assign(:word, ListWords.get_word!(id))
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Words")
    |> assign(:word, nil)
  end

  def handle_event("delete", %{"id" => id}, socket) do
    word = ListWords.get_word!(id)
    {:ok, _} = ListWords.delete_word(word)

    {:noreply, assign(socket, :words, list_words())}
  end

  def handle_event("increment", %{"id" => counter_id}, socket) do
    {:noreply, assign(socket, counters: increment_counters(socket.assigns.counters, counter_id))}
  end

  def handle_event("decrement", %{"id" => counter_id}, socket) do
    {:noreply, assign(socket, counters: decrement_counters(socket.assigns.counters, counter_id))}
  end

  # Functions
  defp gen_counters(n) do
    Enum.to_list(1..n) |> Enum.reduce(%{}, &Map.put(&2, Integer.to_string(&1), 0))
  end

  defp increment_counters(counters, counter_id) do
    Map.update(counters, counter_id, 1, &(&1 + 1))
  end

  defp decrement_counters(counters, counter_id) do
    Map.update(counters, counter_id, 5, &(&1 - 1))
  end

  defp add_counters(counters) do
    length = counters |> Map.keys() |> length()
    Map.put_new(counters, Integer.to_string(length + 1), 0)
  end

  defp list_words do
    ListWords.list_words()
  end
end
