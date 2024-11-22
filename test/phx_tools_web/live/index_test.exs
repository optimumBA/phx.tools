defmodule PhxToolsWeb.PhxToolsLive.IndexTest do
  use PhxToolsWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  describe "/" do
    test "user visits the page with Linux OS user agent", %{conn: conn} do
      updated_conn = put_req_header(conn, "user-agent", "Linux")
      {:ok, landing_live, html} = live(updated_conn, "/")

      assert html =~ "The Complete Development Environment for Elixir and Phoenix"
      assert html =~ "Linux installation process"
      assert html =~ "$SHELL -c &quot;$(curl -fsSL http://localhost:4002)&quot;"
      assert has_element?(landing_live, "#tool-installation")
      assert has_element?(landing_live, "#copy")

      assert has_element?(
               landing_live,
               "a[href='https://github.com/optimumBA/phx.tools/blob/main/priv/script.sh']"
             )

      refute html =~ "Unsupported Operating System Detected"

      refute html =~
               "It looks like you&#39;re using an operating system that Phx.tools doesn&#39;t currently support."
    end

    test "user visits the page with Mac OS user agent", %{conn: conn} do
      updated_conn = put_req_header(conn, "user-agent", "Mac OS X 10_5_7")
      {:ok, landing_live, html} = live(updated_conn, "/")

      assert html =~ "The Complete Development Environment for Elixir and Phoenix"
      assert html =~ "macOS installation process"
      assert html =~ "$SHELL -c &quot;$(curl -fsSL http://localhost:4002)&quot;"
      assert has_element?(landing_live, "#tool-installation")
      assert has_element?(landing_live, "#copy")

      assert has_element?(
               landing_live,
               "a[href='https://github.com/optimumBA/phx.tools/blob/main/priv/script.sh']"
             )

      refute html =~ "Unsupported Operating System Detected"

      refute html =~
               "It looks like you&#39;re using an operating system that Phx.tools doesn&#39;t currently support."
    end

    test "is accessed with unsupported OS", %{conn: conn} do
      updated_conn = put_req_header(conn, "user-agent", "Unsupported OS")
      {:ok, unsupported_os_live, html} = live(updated_conn, "/")

      assert html =~ "The Complete Development Environment for Elixir and Phoenix"
      assert html =~ "Linux installation process"
      assert html =~ "$SHELL -c &quot;$(curl -fsSL http://localhost:4002)&quot;"

      assert has_element?(unsupported_os_live, "#tool-installation")
      assert has_element?(unsupported_os_live, "#copy")

      assert has_element?(
               unsupported_os_live,
               "a[href='https://github.com/optimumBA/phx.tools/blob/main/priv/script.sh']"
             )

      assert html =~ "Unsupported Operating System Detected"

      assert html =~
               "It looks like you&#39;re using an operating system that Phx.tools doesn&#39;t currently support."
    end
  end

  describe "scripts" do
    test "user accesses Linux script", %{conn: conn} do
      conn = get(conn, "/Linux.sh")
      assert conn.resp_body =~ "Welcome to the phx.tools shell script"
    end

    test "user accesses macOS script", %{conn: conn} do
      conn = get(conn, "/macOS.sh")
      assert conn.resp_body =~ "Welcome to the phx.tools shell script"
    end
  end
end
