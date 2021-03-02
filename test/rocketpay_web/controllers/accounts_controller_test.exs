defmodule RocketpayWeb.AccountsControllerTest do
  use RocketpayWeb.ConnCase, async: true

  alias Rocketpay.{Account, User}

  describe "deposit/2" do
    setup %{conn: conn} do
      params = %{
        name: "Adryan",
        password: "123456",
        nickname: "adryansf",
        email: "adryansfreitas@gmail.com",
        age: 19
      }

      {:ok, %User{account: %Account{id: account_id}}} = Rocketpay.create_user(params)

      conn = put_req_header(conn, "authorization", "Basic YWRtaW46YWRtaW4=")

      {:ok, conn: conn, account_id: account_id}
    end


    test "when all params are valid params, do the deposit", %{conn: conn, account_id: account_id} do
      params = %{"value"=> "50.00"}

      response = conn
      |> post(Routes.accounts_path(conn, :deposit, account_id, params))
      |> json_response(:ok)

      assert %{
        "message" => "Ballance changed successfully",
          "account" => %{
            "id"=> _id,
            "balance"=> "50.00"
          }
      } = response
    end

    test "when there are invalid params, returns an error", %{conn: conn, account_id: account_id} do
      params = %{"value"=> "test"}

      response = conn
      |> post(Routes.accounts_path(conn, :deposit, account_id, params))
      |> json_response(:bad_request)

      assert %{
        "message" => "Invalid deposit value!"
      } = response
    end
  end
end
