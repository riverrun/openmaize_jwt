defmodule OpenmaizeJWT.ToolsTest do
  use ExUnit.Case
  use Plug.Test

  alias OpenmaizeJWT.{Config, Tools}

  test "generate signing key" do
    assert Tools.gen_key |> byte_size == 64
    assert Tools.gen_key(96) |> byte_size == 96
  end

  test "raises error for length that is too short" do
    assert_raise ArgumentError, "The signing key should be 64 bytes or longer", fn ->
      Tools.gen_key(63)
    end
  end

  test "get hash" do
    assert Tools.get_mac("", :sha512, Config.signing_key) |> Base.encode64 ==
      "l76RMljGaey7SgPEx96wwgwaW4FCP8LxewK47yjkwZWEryYzda0lvKP1VsCsyRbBqwV/XQTNKEC8v3fZ5XmOkw=="
    assert Tools.get_mac("", :sha256, Config.signing_key) |> Base.encode64 ==
      "RkIANpt0zTldcWPuw91zl/GkLKLiUtLzY/ooqX9ZQeU="
  end

  test "raises error for invalid key" do
    key = String.duplicate("1234567", 9)
    assert_raise ArgumentError, "The signing key should be 64 bytes or longer", fn ->
      Tools.get_mac("", :sha512, key)
    end
    assert_raise ArgumentError, "The signing key should be 64 bytes or longer", fn ->
      Tools.get_mac("", :sha512, nil)
    end
  end

end
