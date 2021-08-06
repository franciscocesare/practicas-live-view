defmodule TwitterClonWeb.CountLive.Show do
  use TwitterClonWeb, :live_view

  alias TwitterClon.Counters

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:count, Counters.get_count!(id))}
  end

  defp page_title(:show), do: "Show Count"
  defp page_title(:edit), do: "Edit Count"
end
