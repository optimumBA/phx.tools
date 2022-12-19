defmodule PhxToolsWeb.LinuxLiveTest do
  use PhxToolsWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  describe "linux instructions page" do
    test "user visits linux instructions page", %{conn: conn} do
      {:ok, linux_live, html} = live(conn, "/linux")

      assert html =~ "Linux installation process"
      assert render(linux_live) =~ "Linux installation process"
      assert has_element?(linux_live, "#tool-installation")
      assert has_element?(linux_live, "#copy")
    end
  end
end
