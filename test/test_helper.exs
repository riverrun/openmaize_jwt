ExUnit.start()

Application.put_env(:openmaize_jwt, :signing_key, String.duplicate("12345678", 8))
