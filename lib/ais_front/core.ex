defmodule AisFront.Core do
  @moduledoc """
  The Core context.
  """

  import Ecto.Query, warn: false
  alias AisFront.RepoBack, as: Repo

  alias AisFront.Core.ShipInfos

  @doc """
  Returns the list of core_shipinfos.

  ## Examples

      iex> list_core_shipinfos()
      [%ShipInfos{}, ...]

  """
  def list_core_shipinfos do
    Repo.all(ShipInfos)
  end

  @doc """
  Gets a single ship_infos.

  Raises `Ecto.NoResultsError` if the Ship infos does not exist.

  ## Examples

      iex> get_ship_infos!(123)
      %ShipInfos{}

      iex> get_ship_infos!(456)
      ** (Ecto.NoResultsError)

  """
  def get_ship_infos!(id), do: Repo.get!(ShipInfos, id)

  @doc """
  Creates a ship_infos.

  ## Examples

      iex> create_ship_infos(%{field: value})
      {:ok, %ShipInfos{}}

      iex> create_ship_infos(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_ship_infos(attrs \\ %{}) do
    %ShipInfos{}
    |> ShipInfos.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a ship_infos.

  ## Examples

      iex> update_ship_infos(ship_infos, %{field: new_value})
      {:ok, %ShipInfos{}}

      iex> update_ship_infos(ship_infos, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_ship_infos(%ShipInfos{} = ship_infos, attrs) do
    ship_infos
    |> ShipInfos.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a ship_infos.

  ## Examples

      iex> delete_ship_infos(ship_infos)
      {:ok, %ShipInfos{}}

      iex> delete_ship_infos(ship_infos)
      {:error, %Ecto.Changeset{}}

  """
  def delete_ship_infos(%ShipInfos{} = ship_infos) do
    Repo.delete(ship_infos)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking ship_infos changes.

  ## Examples

      iex> change_ship_infos(ship_infos)
      %Ecto.Changeset{data: %ShipInfos{}}

  """
  def change_ship_infos(%ShipInfos{} = ship_infos, attrs \\ %{}) do
    ShipInfos.changeset(ship_infos, attrs)
  end
end
