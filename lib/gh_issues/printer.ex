defmodule GhIssues.Printer do
  @moduledoc """
  Eventually will print pretty things
  """
  def foo(input) do
    results = input |> Enum.map(fn(issue) ->
                                  label         = issue["label"]
                                  state         = issue["state"]
                                  body_markdown = issue["body"]
                                  url           = issue["url"]
                                  title         = issue["title"]
                                  %{label: label,
                                    state: state,
                                    body: body_markdown,
                                    url: url,
                                    title: title}
                                end)
  end

  def print_message({label, title, body_markdown, url}) do
    msg = """
___________________________________________________________________________________
#{label}
Issue: #{title}

#{body_markdown}

Github Link: #{url}
          """
    IO.puts msg
  end

end
