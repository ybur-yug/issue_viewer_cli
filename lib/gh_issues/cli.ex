defmodule GhIssues.CLI do
  @default_count 10

  @moduledoc """
  Handle the CLI parsing of github issues and create a table of the last N issues.
  """
  @spec run(list()) :: tuple
  def run(argv) do
    argv |> parse_args |> process
  end

  @doc """
  `argv` can be -h or --help, and returns :help.
  Otherwise it is a Github user name, repo name, & (optionally) the number of entries to format.
  Return a tuple of `{ user, repo, count }`, or `:help` if help was given.
  """
  @spec parse_args(list()) :: list()
  def parse_args(argv) do
    parse = OptionParser.parse(argv, switches: [ help: :boolean],
     aliases: [ h: :help ])
   case parse do
     {[ help: true ], _, _}
     -> :help
     {_, [ user, repo, count ], _}
     -> {user, repo, count |> String.to_integer}
     {_, [ user, repo ], _ }
     -> {user, repo, @default_count}
     _ -> :help
   end
  end

  def process(:help) do
    IO.puts "Usage: issues <user> <repo> [ count | #{@default_count} ]"
    System.halt(0)
  end

  def process({user, repo, count}) do
    c = GhIssues.GithubIssueRetriever.fetch(user, repo)
    a = c |> decode_response
          |> convert_to_list_of_maps
          |> sort_into_ascending_order
          |> GhIssues.Printer.foo
        #  |> Enum.take(count)
  end

  def decode_response({:ok, body}), do: body

  def decode_response({:error, error}) do
    {_, message} = List.keyfind(error, "message", 0)
    IO.puts "Error fetching from Github: #{message}"
    System.halt(2)
  end

  @spec convert_to_list_of_maps(list()) :: list()
  def convert_to_list_of_maps(list) do
    list
    |> Enum.map(&Enum.into(&1, Map.new))
  end

  @spec sort_into_ascending_order(list()) :: list()
  def sort_into_ascending_order(issues) do
    Enum.sort issues,
    fn i, i2 -> i["created_at"] <= i2["created_at"] end
  end

end
