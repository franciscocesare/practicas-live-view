defmodule TwitterClonWeb.CountLive.Index do
  use TwitterClonWeb, :live_view

  alias TwitterClon.Counters
  alias TwitterClon.Counters.Count

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :counters, list_counters())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Count")
    |> assign(:count, Counters.get_count!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Count")
    |> assign(:count, %Count{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Counters")
    |> assign(:count, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    count = Counters.get_count!(id)
    {:ok, _} = Counters.delete_count(count)

    {:noreply, assign(socket, :counters, list_counters())}
  end

  defp list_counters do
    Counters.list_counters()

  end
end
