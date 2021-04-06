defmodule GhostWeb.HomeLiveTest do
  use GhostWeb.ConnCase

  import Phoenix.LiveViewTest

  test "disconnected and connected render", %{conn: conn} do
    {:ok, page_live, disconnected_html} = live(conn, "/")
    assert disconnected_html =~ "What should I do right now?"
    assert render(page_live) =~ "What should I do right now?"
  end
end
