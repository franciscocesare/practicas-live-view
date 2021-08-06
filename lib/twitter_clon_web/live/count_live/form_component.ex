defmodule TwitterClonWeb.CountLive.FormComponent do
  use TwitterClonWeb, :live_component

  alias TwitterClon.Counters

  @impl true
  def update(%{count: count} = assigns, socket) do
    changeset = Counters.change_count(count)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"count" => count_params}, socket) do
    changeset =
      socket.assigns.count
      |> Counters.change_count(count_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"count" => count_params}, socket) do
    save_count(socket, socket.assigns.action, count_params)
  end

  defp save_count(socket, :edit, count_params) do
    case Counters.update_count(socket.assigns.count, count_params) do
      {:ok, _count} ->
        {:noreply,
         socket
         |> put_flash(:info, "Count updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_count(socket, :new, count_params) do
    case Counters.create_count(count_params) do
      {:ok, _count} ->
        {:noreply,
         socket
         |> put_flash(:info, "Count created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
