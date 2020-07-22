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
  Gets a single shipinfos.

  Raises `Ecto.NoResultsError` if the Ship infos does not exist.

  ## Examples

      iex> get_shipinfos!(123)
      %ShipInfos{}

      iex> get_shipinfos!(456)
      ** (Ecto.NoResultsError)

  """
  def get_shipinfos!(id), do: Repo.get!(ShipInfos, id)

  @doc """
  Gets a single shipinfos

  Returns nil if the Ship does not exist

  #Examples

      iex> get_shipinfos(123)
      %ShipInfos{}

      iex> get_shipinfos(456)
      nil

  """
  def get_shipinfos(id), do: Repo.get(ShipInfos, id)

  @doc """
  Creates a shipinfos.

  ## Examples

      iex> create_shipinfos(%{field: value})
      {:ok, %ShipInfos{}}

      iex> create_shipinfos(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_shipinfos(attrs \\ %{}) do
    %ShipInfos{}
    |> ShipInfos.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a shipinfos.

  ## Examples

      iex> update_shipinfos(shipinfos, %{field: new_value})
      {:ok, %ShipInfos{}}

      iex> update_shipinfos(shipinfos, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_shipinfos(%ShipInfos{} = shipinfos, attrs) do
    shipinfos
    |> ShipInfos.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a shipinfos.

  ## Examples

      iex> delete_shipinfos(shipinfos)
      {:ok, %ShipInfos{}}

      iex> delete_shipinfos(shipinfos)
      {:error, %Ecto.Changeset{}}

  """
  def delete_shipinfos(%ShipInfos{} = shipinfos) do
    Repo.delete(shipinfos)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking shipinfos changes.

  ## Examples

      iex> change_shipinfos(shipinfos)
      %Ecto.Changeset{data: %ShipInfos{}}

  """
  def change_shipinfos(%ShipInfos{} = shipinfos, attrs \\ %{}) do
    ShipInfos.changeset(shipinfos, attrs)
  end
end
