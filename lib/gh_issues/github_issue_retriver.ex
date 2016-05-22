defmodule GhIssues.GithubIssueRetriever do
  @moduledoc """
  Github API Interface for issue fetching
  """
  @github_url Application.get_env(:issues, :github_url)

  @user_agent [ {"User-agent", "Bobdawg"} ]

  def fetch(user, repo) do
    issues_url(user, repo)
    |> HTTPoison.get(@user_agent)
    |> handle_response
  end

  @spec issues_url(String.t, String.t) :: String.t
  def issues_url(user, repo) do
    "#{@github_url}/repos/#{user}/#{repo}/issues"
  end

  def handle_response({:ok, %{status_code: 200, body: body}}) do
    {:ok, (body |> Poison.Parser.parse!)}
  end

  def handle_response({_, %{status_code: _, body: body}}) do
    {:error, (body |> Poison.Parser.parse!)}
  end

end
