defmodule TwitterClonWeb.WordLive.Index do
  use TwitterClonWeb, :live_view

  alias TwitterClon.ListWords
  alias TwitterClon.ListWords.Word

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :words, list_words())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Word")
    |> assign(:word, ListWords.get_word!(id))
  end

   defp apply_action(socket, :new, _params) do
     socket
     |> assign(:page_title, "New Word")
     |> assign(:word, %Word{})
   end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Words")
    |> assign(:word, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    word = ListWords.get_word!(id)
    {:ok, _} = ListWords.delete_word(word)

    {:noreply, assign(socket, :words, list_words())}
  end

  defp list_words do
    ListWords.list_words()
  end
end
