defmodule Plugs.OsDetectorTest do
  use PhxToolsWeb.ConnCase, async: true

  describe "call/2" do
    test "gets Linux os user-agent", %{conn: conn} do
      conn =
        conn
        |> put_req_header("user-agent", "Linux")
        |> get("/")

      assert get_session(conn, :operating_system) == "Linux"
    end

    test "gets Mac os from user-agent", %{conn: conn} do
      conn =
        conn
        |> put_req_header("user-agent", "Mac OS X 10_5_7")
        |> get("/")

      assert get_session(conn, :operating_system) == "Mac OS X"
    end

    # fit it after response is sent from designer
    @tag :skip
    test "returns nil if there is no os", %{conn: conn} do
      conn =
        conn
        |> put_req_header("user-agent", "curl")
        |> get("/")

      assert get_session(conn, :operating_system) == nil
    end
  end
end
