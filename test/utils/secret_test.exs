defmodule ResuelveAuth.Utils.SecretTest do
  use ExUnit.Case

  doctest ResuelveAuth.Utils.Secret
  alias ResuelveAuth.Utils.Secret

  @token %ResuelveAuth.TokenData{
    meta: "metadata",
    role: "user",
    service: "my-api",
    session: nil,
    timestamp: 1_594_039_006_911
  }

  describe "[encode] " do
    test "test valid results" do
      {:ok, result} = Secret.encode(@token)

      assert result ==
               ~s({"timestamp":1594039006911,"session":null,"service":"my-api","role":"user","meta":"metadata"})
    end

    test "test valid results with encode64" do
      result =
        @token
        |> Secret.encode()
        |> Secret.encode64()

      assert result ==
               "eyJ0aW1lc3RhbXAiOjE1OTQwMzkwMDY5MTEsInNlc3Npb24iOm51bGwsInNlcnZpY2UiOiJteS1hcGkiLCJyb2xlIjoidXNlciIsIm1ldGEiOiJtZXRhZGF0YSJ9"
    end

    test "test invalid keys" do
      data = %{:foo => "foo1", "foo" => "foo2"}
      result = Secret.encode(data)
      assert {:error, {:invalid, "foo"}} = result
    end

    test "test invalid keys with encode64" do
      result =
        %{:foo => "foo1", "foo" => "foo2"}
        |> Secret.encode()
        |> Secret.encode64()

      assert {:error, {:invalid, "foo"}} = result
    end
  end
end
