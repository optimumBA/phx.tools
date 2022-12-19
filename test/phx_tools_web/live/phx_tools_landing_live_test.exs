defmodule PhxToolsAppTestWeb.PhxToolsLandingLiveTest do
  use PhxToolsWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  describe "landing page" do
    test "user visits the page", %{conn: conn} do
      {:ok, landing_live, html} = live(conn, "/")

      assert html =~ "Choose your operating system"
      assert render(landing_live) =~ "Choose your operating system"
      assert has_element?(landing_live, "#macOS")
      assert has_element?(landing_live, "#linux")
    end
  end
end
