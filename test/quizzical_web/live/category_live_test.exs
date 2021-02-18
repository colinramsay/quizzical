defmodule QuizzicalWeb.CategoryLiveTest do
  use QuizzicalWeb.ConnCase

  import Phoenix.LiveViewTest
  import Quizzical.QuizFixtures
  alias Quizzical.Categories

  @update_attrs %{name: unique_category_name()}
  @invalid_attrs %{name: nil}

  defp create_attrs() do
    %{name: unique_category_name()}
  end

  defp fixture(:category) do
    {:ok, category} = Categories.create_category(create_attrs())
    category
  end

  defp create_category(_) do
    category = fixture(:category)
    %{category: category}
  end

  describe "Index" do
    setup [:create_category]

    setup :register_and_log_in_admin

    test "lists all categories", %{conn: conn, category: category} do
      {:ok, _index_live, html} = live(conn, Routes.category_index_path(conn, :index))

      assert html =~ "Listing Categories"
      assert html =~ category.name
    end

    test "saves new category", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.category_index_path(conn, :index))

      assert index_live |> element("a", "New Category") |> render_click() =~
               "New Category"

      assert_patch(index_live, Routes.category_index_path(conn, :new))

      assert index_live
             |> form("#category-form", category: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      new_category_attrs = create_attrs()

      {:ok, _, html} =
        index_live
        |> form("#category-form", category: new_category_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.category_index_path(conn, :index))

      assert html =~ "Category created successfully"
      assert html =~ new_category_attrs.name
    end

    test "updates category in listing", %{conn: conn, category: category} do
      {:ok, index_live, _html} = live(conn, Routes.category_index_path(conn, :index))

      assert index_live |> element("#category-#{category.id} a.edit", "Edit") |> render_click() =~
               "Edit Category"

      assert_patch(index_live, Routes.category_index_path(conn, :edit, category))

      assert index_live
             |> form("#category-form", category: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#category-form", category: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.category_index_path(conn, :index))

      assert html =~ "Category updated successfully"
      assert html =~ @update_attrs.name
    end

    test "deletes category in listing", %{conn: conn, category: category} do
      {:ok, index_live, _html} = live(conn, Routes.category_index_path(conn, :index))

      assert index_live
             |> element("#category-#{category.id} a.delete", "Delete")
             |> render_click()

      refute has_element?(index_live, "#category-#{category.id}")
    end
  end

  # describe "Show" do
  #   setup [:create_category]

  #   test "displays category", %{conn: conn, category: category} do
  #     {:ok, _show_live, html} = live(conn, Routes.category_show_path(conn, :show, category))

  #     assert html =~ "Show Category"
  #     assert html =~ category.name
  #   end

  #   test "updates category within modal", %{conn: conn, category: category} do
  #     {:ok, show_live, _html} = live(conn, Routes.category_show_path(conn, :show, category))

  #     assert show_live |> element("a", "Edit") |> render_click() =~
  #              "Edit Category"

  #     assert_patch(show_live, Routes.category_show_path(conn, :edit, category))

  #     assert show_live
  #            |> form("#category-form", category: @invalid_attrs)
  #            |> render_change() =~ "can&apos;t be blank"

  #     {:ok, _, html} =
  #       show_live
  #       |> form("#category-form", category: @update_attrs)
  #       |> render_submit()
  #       |> follow_redirect(conn, Routes.category_show_path(conn, :show, category))

  #     assert html =~ "Category updated successfully"
  #     assert html =~ "some updated name"
  #   end
  # end
end
