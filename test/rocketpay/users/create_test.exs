defmodule Rocketpay.Users.CreateTest do
  use Rocketpay.DataCase

  alias Rocketpay.User
  alias Rocketpay.Users.Create

  describe "call/1" do
    test "when all params are valid, returns a user" do
      params = %{
        name: "Joao",
        password: "123456",
        nickname: "joao",
        email: "joao@teste.com",
        age: 29
      }

      {:ok, %User{id: user_id}} = Create.call(params)
      user = Repo.get(User, user_id)

      assert %User{name: "Joao", age: 29, id: ^user_id} = user
    end

    test "when there are invalid params, returns an error" do
      params = %{
        name: "Joao",
        nickname: "joao",
        email: "joao@teste.com",
        age: 15
      }

      {:error, changeset} = Create.call(params)

      expected_response = %{
        age: ["must be greater than or equal to 18"],
        password: ["can't be blank"]
      }

      assert errors_on(changeset) == expected_response
    end
  end
end
