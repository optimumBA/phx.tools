defmodule PhxToolsWeb.PhxToolsLandingLiveTest do
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

  describe "linux instructions page" do
    test "user visits linux instructions page", %{conn: conn} do
      {:ok, linux_live, html} = live(conn, "/linux")

      assert html =~ "Linux installation process"
      assert render(linux_live) =~ "Linux installation process"
      assert has_element?(linux_live, "#tool-installation")
      assert has_element?(linux_live, "#copy")
    end
  end

  describe "macos instructions page" do
    test "user visits macos instructions page", %{conn: conn} do
      {:ok, linux_live, html} = live(conn, "/macOS")

      assert html =~ "macOS installation process"
      assert render(linux_live) =~ "macOS installation process"
      assert has_element?(linux_live, "#tool-installation")
      assert has_element?(linux_live, "#copy")
    end
  end
end
