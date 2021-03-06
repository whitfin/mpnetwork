defmodule MpnetworkWeb.PageControllerTest do
  use MpnetworkWeb.ConnCase, async: true

  import Mpnetwork.Test.Support.Utilities

  test "GET / requires login", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 302) =~ "/sessions/new"
  end

  test "GET / with login works", %{conn: conn} do
    user = user_fixture()

    conn =
      conn
      |> assign(:current_user, user)
      |> get("/")

    assert html_response(conn, 200) =~ "No listings"
  end
end
