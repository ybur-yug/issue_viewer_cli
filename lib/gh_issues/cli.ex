defmodule GhIssues.CLI do
  @default_count 10

  @moduledoc """
  Handle the CLI parsing of github issues and create a table of the last N issues.
  """
  @spec run(list) :: tuple
  def run(argv) do
    argv |> parse_args |> process
  end

  @doc """
  `argv` can be -h or --help, and returns :help.
  Otherwise it is a Github user name, repo name, & (optionally) the number of entries to format.
  Return a tuple of `{ user, repo, count }`, or `:help` if help was given.
  """
  @spec parse_args(list) :: list()
  def parse_args(argv) do
    parse = OptionParser.parse(argv, switches: [ help: :boolean],
     aliases: [ h: :help ])
   case parse do
     {[ help: true ], _, _}
     -> :help
     {_, [ user, repo, count ], _}
     -> { user, repo, count |> String.to_integer}
     {_, [ user, repo ], _ }
     -> { user, repo, @default_count}
     _ -> :help
   end
  end

  def process(:help) do
    IO.puts "Usage: issues <user> <repo> [ count | #{@default_count} ]"
    System.halt(0)
  end

  def process({user, repo, _count}) do
    GhIssues.GithubIssueRetriever.fetch(user, repo)
  end
    
end
