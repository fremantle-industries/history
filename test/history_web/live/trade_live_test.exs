defmodule HistoryWeb.TradeLiveTest do
  use HistoryWeb.ConnCase

  import Phoenix.LiveViewTest

  test "disconnected and connected render", %{conn: conn} do
    {:ok, page_live, disconnected_html} = live(conn, "/data/trade")
    assert disconnected_html =~ "Jobs"
    assert render(page_live) =~ "Jobs"
  end
end
