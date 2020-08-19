defmodule Adoptoposs.Network.Api.Gitlab do
  alias Adoptoposs.Network.{Api, Repository, PageInfo, Organization}
  alias Adoptoposs.Network.Repository.{User, Language}

  @behaviour Api

  @api_uri "https://gitlab.com/api/v4"

  @impl Api
  def organizations(token, limit, after_cursor) do
    {:ok, {%PageInfo{}, []}}
  end

  @impl Api
  def repos(token, organization, limit, after_cursor) do
    {:ok, {%PageInfo{}, []}}
  end

  @impl Api
  def user_repos(token, limit, after_cursor) do
    {:ok, {%PageInfo{}, []}}
  end

  defp compile_user_repos(_data), do: []

  defp build_organization(%{viewerCanAdminister: true} = data) do
    %Organization{
      id: data.login,
      name: data.name,
      description: data.description,
      avatar_url: data.avatarUrl
    }
  end

  defp build_organization(_data), do: nil

  defp build_repository(%{id: id, name: name, descriptionHTML: description, url: url} = data) do
    %Repository{
      id: id,
      name: name,
      description: description,
      url: url,
      language: build_language(data),
      owner: build_owner(data)
    }
  end

  defp build_repository(_data), do: []

  defp build_owner(%{owner: owner}) when not is_nil(owner) do
    %User{
      login: owner.login,
      avatar_url: owner.avatarUrl,
      profile_url: owner.url
    }
  end

  defp build_owner(_data), do: %User{}

  defp build_language(%{primaryLanguage: language}) when not is_nil(language) do
    struct(Language, language)
  end

  defp build_language(_data), do: %Language{}
end
