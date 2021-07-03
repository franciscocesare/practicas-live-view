defmodule TwitterClonWeb.PageLive do
  use TwitterClonWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, counters: gen_counters(10), word: "", results: [])}
  end
  
  #Events
  def handle_event("create", _params, socket) do
    {:noreply, assign(socket, counters: add_counters(socket.assigns.counters))}
    
  end
  def handle_event("increment", %{"id" => counter_id}, socket) do
    {:noreply, assign(socket, counters: increment_counters(socket.assigns.counters, counter_id))}
  end

  def handle_event("decrement", %{"id" => counter_id}, socket) do
    {:noreply, assign(socket, counters: decrement_counters(socket.assigns.counters, counter_id))}
  end
  

  def handle_event("add", %{"w" => word}, socket) do
    {:noreply, assign(socket, results: add_words(socket.assigns.results, word))}
  end
  
  def handle_event("delete_word", %{"value" => word}, socket) do
   # IO.inspect(word)
  {:noreply, assign(socket, results: delete_words(socket.assigns.results, word))}
  end 
  
  #Functions
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
    Map.put_new(counters, Integer.to_string(length+1), 0) 
  end
  
  defp add_words(results, word) do
    length = results |> length()
    results |> List.insert_at(length, word) 
  end
  
  defp delete_words(results, word) do
    results |> List.delete(word)
  end
  
end