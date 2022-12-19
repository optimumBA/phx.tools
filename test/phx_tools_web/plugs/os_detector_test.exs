defmodule Plugs.OsDetectorTest do
  use PhxToolsWeb.ConnCase, async: true

  describe "call/2" do
    test "gets Linux os user-agent", %{conn: conn} do
      conn =
        conn
        |> put_req_header("user-agent", "Linux")
        |> get("/")

      assert get_session(conn, :operating_system) == %UAParser.UA{
               device: %UAParser.Device{brand: nil, family: nil, model: nil},
               family: nil,
               os: %UAParser.OperatingSystem{
                 family: "Linux",
                 version: %UAParser.Version{major: nil, minor: nil, patch: nil, patch_minor: nil}
               },
               version: nil
             }
    end

    test "gets Mac os from user-agent", %{conn: conn} do
      conn =
        conn
        |> put_req_header("user-agent", "Mac OS X 10_5_7")
        |> get("/")

      assert get_session(conn, :operating_system) == %UAParser.UA{
               device: %UAParser.Device{brand: "Apple", family: "Mac", model: "Mac"},
               family: nil,
               os: %UAParser.OperatingSystem{
                 family: "Mac OS X",
                 version: %UAParser.Version{major: "10", minor: "5", patch: "7", patch_minor: nil}
               },
               version: nil
             }
    end
  end
end
