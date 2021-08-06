defmodule TwitterClonWeb.CountLiveTest do
  use TwitterClonWeb.ConnCase

  import Phoenix.LiveViewTest

  alias TwitterClon.Counters

  @create_attrs %{initial_count: 42, name_counter: "some name_counter"}
  @update_attrs %{initial_count: 43, name_counter: "some updated name_counter"}
  @invalid_attrs %{initial_count: nil, name_counter: nil}

  defp fixture(:count) do
    {:ok, count} = Counters.create_count(@create_attrs)
    count
  end

  defp create_count(_) do
    count = fixture(:count)
    %{count: count}
  end

  describe "Index" do
    setup [:create_count]

    test "lists all counters", %{conn: conn, count: count} do
      {:ok, _index_live, html} = live(conn, Routes.count_index_path(conn, :index))

      assert html =~ "Listing Counters"
      assert html =~ count.name_counter
    end

    test "saves new count", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.count_index_path(conn, :index))

      assert index_live |> element("a", "New Count") |> render_click() =~
               "New Count"

      assert_patch(index_live, Routes.count_index_path(conn, :new))

      assert index_live
             |> form("#count-form", count: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#count-form", count: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.count_index_path(conn, :index))

      assert html =~ "Count created successfully"
      assert html =~ "some name_counter"
    end

    test "updates count in listing", %{conn: conn, count: count} do
      {:ok, index_live, _html} = live(conn, Routes.count_index_path(conn, :index))

      assert index_live |> element("#count-#{count.id} a", "Edit") |> render_click() =~
               "Edit Count"

      assert_patch(index_live, Routes.count_index_path(conn, :edit, count))

      assert index_live
             |> form("#count-form", count: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#count-form", count: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.count_index_path(conn, :index))

      assert html =~ "Count updated successfully"
      assert html =~ "some updated name_counter"
    end

    test "deletes count in listing", %{conn: conn, count: count} do
      {:ok, index_live, _html} = live(conn, Routes.count_index_path(conn, :index))

      assert index_live |> element("#count-#{count.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#count-#{count.id}")
    end
  end

  describe "Show" do
    setup [:create_count]

    test "displays count", %{conn: conn, count: count} do
      {:ok, _show_live, html} = live(conn, Routes.count_show_path(conn, :show, count))

      assert html =~ "Show Count"
      assert html =~ count.name_counter
    end

    test "updates count within modal", %{conn: conn, count: count} do
      {:ok, show_live, _html} = live(conn, Routes.count_show_path(conn, :show, count))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Count"

      assert_patch(show_live, Routes.count_show_path(conn, :edit, count))

      assert show_live
             |> form("#count-form", count: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#count-form", count: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.count_show_path(conn, :show, count))

      assert html =~ "Count updated successfully"
      assert html =~ "some updated name_counter"
    end
  end
end
