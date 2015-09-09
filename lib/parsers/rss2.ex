defmodule Feedme.Parsers.RSS2 do
  def valid?(document) do
    case document do
      %{attr: [version: "2.0"]} -> true
      _ -> false
    end
  end  
end
