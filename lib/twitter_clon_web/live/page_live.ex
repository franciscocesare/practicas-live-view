defmodule TwitterClonWeb.PageLive do
  use TwitterClonWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    counters = Enum.to_list(1..10) |> Enum.map(fn x -> %{:id => x, :count => 1} end)
    {:ok, assign(socket, counters: counters , query: "", results: %{})}
  end

  def handle_event("increment", %{"id" => params}, socket) do
    #IO.inspect(socket.assigns)
    update_list = socket.assigns.counters
    |> Enum.map(fn item -> if item.id == params, do: %{count: item.count + 1, id: item.id}, else: item end)
    
    # case Enum.filter(socket.assigns.counters, fn x -> Map.has_key?(x, "count") end) do
    #   :true -> IO.puts("oh yeah")
    #   [] -> IO.puts("oh nao") #este puse porque me devolvia una lista vacia
        
    {:noreply, assign(socket, counters: update_list)} #mal
  end           #tengo que ver como accedo al count de c/counter

  def handle_event("decrement", %{"id" => params_id}, socket) do
    IO.inspect(socket.assigns.counters)
    update_list = socket.assigns.counters 
    |> Enum.map(fn item -> if item.id == params_id, do: IO.puts("Holis"), else: IO.puts(item.id) end)
    #IO.inspect(update_list)
    {:noreply, assign(socket, counters: update_list)} 
    
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
end
