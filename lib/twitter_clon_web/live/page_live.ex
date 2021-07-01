defmodule TwitterClonWeb.PageLive do
  use TwitterClonWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, counters: gen_counters(10) , query: "", results: %{})}
  end

  def handle_event("increment", params, socket) do

    IO.inspect params
    %{"id" => counter_id} = params
    {:noreply, assign(socket, counters: increment_counters(socket.assigns.counters, counter_id))}
  end

  def handle_event("decrement", %{"id" => counter_id}, socket) do
    {:noreply, assign(socket, counters: decrement_counters(socket.assigns.counters, counter_id))}
  end

  @impl true
  def handle_event("suggest", %{"q" => query}, socket) do
    {:noreply, assign(socket, results: search(query), query: query)}
  end

  @impl true
  def handle_event("search", %{"q" => query}, socket) do
    case search(query) do
      %{^query => vsn} ->
        {:noreply, redirect(socket, external: "https://hexdocs.pm/#{query}/#{vsn}")}

      _ ->
        {:noreply,
         socket
         |> put_flash(:error, "No dependencies found matching \"#{query}\"")
         |> assign(results: %{}, query: query)}
    end
  end

  defp search(query) do
    if not TwitterClonWeb.Endpoint.config(:code_reloader) do
      raise "action disabled when not in development"
    end

    for {app, desc, vsn} <- Application.started_applications(),
        app = to_string(app),
        String.starts_with?(app, query) and not List.starts_with?(desc, ~c"ERTS"),
        into: %{},
        do: {app, vsn}
  end

  defp gen_counters(n) do
    Enum.to_list(1..n) |> Enum.reduce(%{}, &Map.put(&2, Integer.to_string(&1), 0))
  end
  defp increment_counters(counters, counter_id) do
    Map.update(counters, counter_id, 1, &(&1 + 1))
  end
  defp decrement_counters(counters, counter_id) do
    Map.update(counters, counter_id, 1, &(&1 - 1))
  end
end
