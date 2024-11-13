defmodule PhxToolsWeb.CurlDetectorTest do
  use PhxToolsWeb.ConnCase, async: true
  #   use Plug.Test

  @script_content "#!/bin/sh"

  describe "call/2" do
    test "returns script content for requests with curl User-Agent on root path", %{conn: conn} do
      conn =
        conn
        |> put_req_header("user-agent", "curl/7.68.0")
        |> get("/")

      assert conn.status == 200
      assert String.contains?(conn.resp_body, @script_content)
    end

    test "returns script content for /macOS.sh regardless of User-Agent,", %{conn: conn} do
      conn =
        conn
        |> put_req_header("user-agent", "curl/7.68.0")
        |> get("/macOS.sh")

      assert conn.status == 200
      assert String.contains?(conn.resp_body, @script_content)
    end

    test "returns script content for /Linux.sh regardless of User-Agent,", %{conn: conn} do
      conn =
        conn
        |> put_req_header("user-agent", "curl/7.68.0")
        |> get("/Linux.sh")

      assert conn.status == 200
      assert String.contains?(conn.resp_body, @script_content)
    end

    test "does not return script content for requests with non-curl User-Agent", %{conn: conn} do
      conn =
        conn
        |> put_req_header("user-agent", "Mozilla/5.0")
        |> get("/macOS.sh")

      assert conn.status == 200
      refute conn.resp_body == @script_content
    end
  end
end
