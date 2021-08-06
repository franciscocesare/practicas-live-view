defmodule TwitterClonWeb.WordLive.FormComponent do
  use TwitterClonWeb, :live_component

  alias TwitterClon.ListWords

  @impl true
  def update(%{word: word} = assigns, socket) do
    changeset = ListWords.change_word(word)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"word" => word_params}, socket) do
    changeset =
      socket.assigns.word
      |> ListWords.change_word(word_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"word" => word_params}, socket) do
    save_word(socket, socket.assigns.action, word_params)
  end

  defp save_word(socket, :edit, word_params) do
    case ListWords.update_word(socket.assigns.word, word_params) do
      {:ok, _word} ->
        {:noreply,
         socket
         |> put_flash(:info, "Word updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_word(socket, :new, word_params) do
    case ListWords.create_word(word_params) do
      {:ok, _word} ->
        {:noreply,
         socket
         |> put_flash(:info, "Word created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
