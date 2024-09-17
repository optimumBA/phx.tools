defmodule PhxToolsWeb.PhxToolsLive.IndexTest do
  use PhxToolsWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  describe "/" do
    test "background of macOS card changes when macOS user clicks to visit the page", %{
      conn: conn
    } do
      conn = put_req_header(conn, "user-agent", "Mac OS X 10_5_7")

      {:ok, landing_live, html} = live(conn, "/")

      assert html =~ "The Complete Development Environment for Elixir and Phoenix"

      assert render(landing_live) =~ "bg-indigo-850"
    end

    test "background of Linux card changes when Linux user clicks to visit the page", %{
      conn: conn
    } do
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
      assert has_element?(landing_live, "#Linux")
    end

    test "is accessed with unsupported OS", %{conn: conn} do
      updated_conn = put_req_header(conn, "user-agent", "Unsupported OS")
      {:ok, unsupported_os_live, html} = live(updated_conn, "/")

      assert html =~ "Unsupported Operating System Detected"
      assert has_element?(unsupported_os_live, "a[href='https://phx.tools/macos']")

      assert render(unsupported_os_live) =~
               "It looks like you&#39;re using an operating system that Phx.tools doesn&#39;t currently support."
    end

    test "has correct source code URL for Linux OS", %{conn: conn} do
      updated_conn = put_req_header(conn, "user-agent", "Linux")
      {:ok, landing_live, html} = live(updated_conn, "/")

      assert html =~ "The Complete Development Environment for Elixir and Phoenix"

      assert has_element?(
               landing_live,
               "a[href='https://github.com/optimumBA/phx.tools/blob/main/priv/static/Linux.sh']"
             )

      refute has_element?(
               landing_live,
               "a[href='https://github.com/optimumBA/phx.tools/blob/main/priv/static/Unsupported%20OS.sh']"
             )
    end

    test "has correct source code URL for macOS", %{conn: conn} do
      updated_conn = put_req_header(conn, "user-agent", "Mac OS X 10_5_7")
      {:ok, landing_live, html} = live(updated_conn, "/")

      assert html =~ "The Complete Development Environment for Elixir and Phoenix"

      assert has_element?(
               landing_live,
               "a[href='https://github.com/optimumBA/phx.tools/blob/main/priv/static/macOS.sh']"
             )

      refute has_element?(
               landing_live,
               "a[href='https://github.com/optimumBA/phx.tools/blob/main/priv/static/Unsupported%20OS.sh']"
             )
    end
  end

  describe "/linux" do
    test "user visits Linux instructions page", %{conn: conn} do
      {:ok, linux_live, html} = live(conn, "/linux")

      assert html =~ "Linux installation process"
      assert render(linux_live) =~ "Linux installation process"
      assert has_element?(linux_live, "#tool-installation")
      assert has_element?(linux_live, "#copy")

      assert has_element?(
               linux_live,
               "a[href='https://github.com/optimumBA/phx.tools/blob/main/priv/static/Linux.sh']"
             )
    end
  end

  describe "/macos" do
    test "user visits macOS instructions page", %{conn: conn} do
      {:ok, macos_live, html} = live(conn, "/macos")

      assert html =~ "macOS installation process"
      assert has_element?(macos_live, "#tool-installation")
      assert has_element?(macos_live, "#copy")

      assert has_element?(
               macos_live,
               "a[href='https://github.com/optimumBA/phx.tools/blob/main/priv/static/macOS.sh']"
             )
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
