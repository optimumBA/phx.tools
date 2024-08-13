defmodule PhxToolsWeb.PhxToolsLive.IndexTest do
  use PhxToolsWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  describe "landing page" do
    test "background of macOS card changes when macOS user visits the page", %{conn: conn} do
      conn = put_req_header(conn, "user-agent", "Mac OS X 10_5_7")

      {:ok, landing_live, html} = live(conn, "/")

      assert html =~ "The Complete Development Environment for Elixir and Phoenix"

      assert render(landing_live) =~ "bg-indigo-850"
    end

    test "background of Linux card changes when Linux user visits the page", %{conn: conn} do
      conn = put_req_header(conn, "user-agent", "Linux")

      {:ok, landing_live, html} = live(conn, "/")

      assert html =~ "The Complete Development Environment for Elixir and Phoenix"

      assert render(landing_live) =~ "bg-indigo-850"
    end

    test "user visits the page with Linux OS user agent", %{conn: conn} do
      updated_conn = put_req_header(conn, "user-agent", "Linux")
      {:ok, landing_live, html} = live(updated_conn, "/")

      assert html =~ "The Complete Development Environment for Elixir and Phoenix"
      assert html =~ "Linux.sh"

      assert has_element?(landing_live, "#macOS")
    end

    test "user visits the page with Mac OS user agent", %{conn: conn} do
      updated_conn = put_req_header(conn, "user-agent", "Mac OS X 10_5_7")
      {:ok, landing_live, html} = live(updated_conn, "/")

      assert html =~ "The Complete Development Environment for Elixir and Phoenix"
      assert html =~ "macOS.sh"
      assert has_element?(landing_live, "#linux")
    end

    test "if there is no operating system confirm message is not displayed", %{conn: conn} do
      {:ok, landing_live, _html} = live(conn, "/")

      refute has_element?(landing_live, "#confirmation")
    end
  end

  describe "Linux instructions page" do
    test "user visits Linux instructions page", %{conn: conn} do
      {:ok, linux_live, html} = live(conn, "/linux")

      assert html =~ "Linux installation process"
      assert render(linux_live) =~ "Linux installation process"
      assert has_element?(linux_live, "#tool-installation")
      assert has_element?(linux_live, "#copy")
    end
  end

  describe "macOS instructions page" do
    test "user visits macOS instructions page", %{conn: conn} do
      {:ok, linux_live, html} = live(conn, "/macOS")

      assert html =~ "macOS installation process"
      assert render(linux_live) =~ "macOS installation process"
      assert has_element?(linux_live, "#tool-installation")
      assert has_element?(linux_live, "#copy")
    end
  end

  describe "scripts" do
    test "user accesses Linux script", %{conn: conn} do
      conn = get(conn, "/Linux.sh")
      assert conn.resp_body =~ "Welcome to the phx.tools shell script for Linux-based OS."
    end

    test "user accesses macOS script", %{conn: conn} do
      conn = get(conn, "/macOS.sh")
      assert conn.resp_body =~ "Welcome to the phx.tools shell script for macOS."
    end
  end
end
