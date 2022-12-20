defmodule PhxToolsWeb.HealthControllerTest do
  use PhxToolsWeb.ConnCase, async: true

  describe "index" do
    test "returns node info", %{conn: conn} do
      conn = get(conn, ~p"/health")

      assert %{
               "connected_to" => [],
               "hostname" => _,
               "node" => "nonode@nohost",
               "status" => "ok"
             } = json_response(conn, 200)
    end
  end
end
