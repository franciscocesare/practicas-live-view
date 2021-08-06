defmodule TwitterClonWeb.PageLive do
  use TwitterClonWeb, :live_view
  
  alias TwitterClon.ListWords
  alias TwitterClon.ListWords.Word
  
  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, counters: gen_counters(1), words: list_words())}
  end

  # Events
  
  # def handle_event("create", _params, socket) do
  #   {:noreply, assign(socket, counters: add_counters(socket.assigns.counters))}
  # end

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

  # defp add_counters(counters) do
  #   length = counters |> Map.keys() |> length()
  #   Map.put_new(counters, Integer.to_string(length + 1), 0)
  # end
  
   defp list_words do
     ListWords.list_words()
   end

end
