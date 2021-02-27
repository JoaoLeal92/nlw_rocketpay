defmodule RocketpayWeb.AccountsControllerTest do
  use RocketpayWeb.ConnCase

  alias Rocketpay.{Account, User}

  describe "deposit/2" do
    setup %{conn: conn} do
      params = %{
        name: "Joao",
        password: "123456",
        nickname: "joao",
        email: "joao@teste.com",
        age: 29
      }

      {:ok, %User{account: %Account{id: account_id}}} = Rocketpay.create_user(params)

      conn = put_req_header(conn, "authorization", "Basic am9hbzoxMjM0NTY=")

      {:ok, conn: conn, account_id: account_id}
    end

    test "when all params are valid, make the deposit", %{conn: conn, account_id: account_id} do
      params = %{"value" => "50.00"}

      response = conn
      |>post(Routes.accounts_path(conn, :deposit, account_id, params))
      |>json_response(:ok)

      assert %{
        "account" => %{"balance" => "50.00", "id" => _id},
        "message" => "Balance changed successfully"
      } = response
    end

    test "when there are invalid params, returns an error", %{conn: conn, account_id: account_id} do
      params = %{"value" => "wrong_params"}

      response = conn
      |>post(Routes.accounts_path(conn, :deposit, account_id, params))
      |>json_response(:bad_request)

      expected_response = %{"message" => "Invalid deposit value!"}

      assert response == expected_response
    end
  end
end
