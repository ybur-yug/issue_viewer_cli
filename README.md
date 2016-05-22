# Github Issue Viewer (CLI)
Based exactly off the Programming Elixir 1.2 book's example of the same thing.
I plan to extend it and customize with special features for triaging Ecto, Phoenix, and Elixir issues.
It is a complete work in progress and has no real features except grabbing issues from the API right now.

## Usage

```elixir
GhIssues.GithubIssueRetriever.fetch("ybur-yug", "gkv")
# => {:ok, a_bunch_of_maps_parsed_from_json}
```

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add gh_issues to your list of dependencies in `mix.exs`:

        def deps do
          [{:gh_issues, "~> 0.0.1"}]
        end

  2. Ensure gh_issues is started before your application:

        def application do
          [applications: [:gh_issues]]
        end

