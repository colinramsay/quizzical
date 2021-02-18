defmodule QuizzicalWeb.PageTest do
  use QuizzicalWeb.ConnCase, async: true

  describe "GET /attribution" do
    test "renders the attribution page", %{conn: conn} do
      conn = get(conn, Routes.page_path(conn, :attribution))
      response = html_response(conn, 200)
      assert response =~ "<h2>Credits &amp; attribution</h2>"
    end
  end

  describe "GET /privacy" do
    test "renders the privacy page", %{conn: conn} do
      conn = get(conn, Routes.page_path(conn, :privacy))
      response = html_response(conn, 200)
      assert response =~ "<h2>Privacy Policy for Quizzical - Pub Quiz Builder</h2>"
    end
  end
end
