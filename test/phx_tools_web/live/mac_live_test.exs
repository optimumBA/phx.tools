defmodule PhxToolsWeb.MacLiveTest do
  use PhxToolsWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  describe "linux instructions page" do
    test "user visits linux instructions page", %{conn: conn} do
      {:ok, linux_live, html} = live(conn, "/macOS")

      assert html =~ "macOS installation process"
      assert render(linux_live) =~ "macOS installation process"
      assert has_element?(linux_live, "#tool-installation")
      assert has_element?(linux_live, "#copy")
    end
  end
end
