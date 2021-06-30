defmodule TwitterClonWeb.PageLive do
  use TwitterClonWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    counters = Enum.to_list(1..10) |> Enum.map(fn x -> %{:id => x, :count => 0} end)
    {:ok, assign(socket, counters: counters , query: "", results: %{})}
  end

  def handle_event("increment", %{"id" => params}, socket) do
    IO.inspect(socket.assigns)
    case Enum.filter(socket.assigns.counters, fn x -> Map.has_key?(x, "count") end) do
      :true -> IO.puts("oh yeah")
      [] -> IO.puts("oh nao") #este puse porque me devolvia una lista vacia
    end
    # case Map.has_key?(socket.assigns.counters, params) do
    #   :true -> Map.get_and_update(socket.assigns.counters, [params, "count"], &(&1 + 1))
    #   :false -> IO.puts("NO NO NOOO ")
    # end
    IO.inspect(params) #asi params trae el id 
    {:noreply, assign(socket, counters: socket.assigns.counters[params].count + 1)} #mal
  end           #tengo que ver como accedo al count de c/counter

  #los params son los phx-value y eso del html. o en mi caso el id
  def handle_event("decrement", params, socket) do
    IO.inspect(params)
    {:noreply, assign(socket, counters: socket.assigns.counters[params["id"]].count-1)} #key es counters, value de esekey??
   # {:noreply, assign(socket, count: socket.assigns.counters[params["id"]].count-1)}
    IO.inspect(socket)
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
