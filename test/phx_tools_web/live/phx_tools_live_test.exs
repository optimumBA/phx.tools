defmodule PhxToolsWeb.PhxToolsLive.IndexTest do
  use PhxToolsWeb.ConnCase, async: true

  import Phoenix.ConnTest
  import Phoenix.LiveViewTest

  describe "landing page" do
    test "user visits the page", %{conn: conn} do
      {:ok, landing_live, html} = live(conn, "/")

      assert html =~ "Choose your operating system"
      assert render(landing_live) =~ "Choose your operating system"
      assert has_element?(landing_live, "#macOS")
      assert has_element?(landing_live, "#linux")
    end

    test "if there is no operating system confirm message is not displayed", %{conn: conn} do
      {:ok, landing_live, _html} = live(conn, "/")

      refute has_element?(landing_live, "#confirmation")
    end
  end

  describe "linux instructions page" do
    test "user visits linux instructions page", %{conn: conn} do
      conn =
        conn
        |> put_req_header("user-agent", "Linux")
        |> get("/")

      {:ok, linux_live, html} = live(conn, "/linux")

      assert html =~ "Linux installation process"
      assert render(linux_live) =~ "Linux installation process"
      assert has_element?(linux_live, "#tool-installation")
      assert has_element?(linux_live, "#copy")
    end
  end

  describe "macos instructions page" do
    test "user visits macos instructions page", %{conn: conn} do
      conn =
        conn
        |> put_req_header("user-agent", "Mac OS X 10_5_7")
        |> get("/")

      {:ok, linux_live, html} = live(conn, "/macOS")

      assert html =~ "macOS installation process"
      assert render(linux_live) =~ "macOS installation process"
      assert has_element?(linux_live, "#tool-installation")
      assert has_element?(linux_live, "#copy")
    end
  end
end
