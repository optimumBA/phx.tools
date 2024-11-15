defmodule PhxToolsWeb.CurlDetectorTest do
  use PhxToolsWeb.ConnCase, async: true

  @script_content "Welcome to the phx.tools shell script"

  describe "call/2" do
    test "responds with script content for requests sent from curl", %{conn: conn} do
      conn =
        conn
        |> put_req_header("user-agent", "curl/7.68.0")
        |> get("/")

      assert conn.status == 200
      assert String.contains?(conn.resp_body, @script_content)
    end

    test "responds with website content for requests not sent from curl", %{conn: conn} do
      conn =
        conn
        |> put_req_header("user-agent", "Mozilla/5.0")
        |> get("/")

      assert conn.status == 200
      refute String.contains?(conn.resp_body, @script_content)
      assert String.contains?(conn.resp_body, "<html")
    end

    test "responds with the script for /Linux.sh regardless of User-Agent", %{conn: conn} do
      conn =
        conn
        |> put_req_header("user-agent", "Mozilla/5.0")
        |> get("/Linux.sh")

      assert conn.status == 200
      assert String.contains?(conn.resp_body, @script_content)
    end

    test "responds with the script for /macOS.sh regardless of User-Agent", %{conn: conn} do
      conn =
        conn
        |> put_req_header("user-agent", "Mozilla/5.0")
        |> get("/macOS.sh")

      assert conn.status == 200
      assert String.contains?(conn.resp_body, @script_content)
    end

    test "doesn't crash when User-Agent is nil", %{conn: conn} do
      conn = get(conn, "/")
      assert conn.status == 200
    end
  end
end
