defmodule AisFront.Core do
  @moduledoc """
  The Core context.
  """

  import Ecto.Query, warn: false
  alias AisFront.RepoBack, as: Repo

  alias AisFront.Core.Shipinfos

  @doc """
  Returns the list of core_shipinfos.

  ## Examples

      iex> list_shipinfos()
      [%Shipinfos{}, ...]

  """
  def list_shipinfos do
    Repo.all(Shipinfos)
  end

  @doc """
  Gets a single shipinfos.

  Raises `Ecto.NoResultsError` if the Ship infos does not exist.

  ## Examples

      iex> get_shipinfos!(123)
      %Shipinfos{}

      iex> get_shipinfos!(456)
      ** (Ecto.NoResultsError)

  """
  def get_shipinfos!(mmsi), do: Repo.get!(Shipinfos, mmsi)

  @doc """
  Gets a single shipinfos

  Returns nil if the Ship does not exist

  #Examples

      iex> get_shipinfos(123)
      %Shipinfos{}

      iex> get_shipinfos(456)
      nil

  """
  def get_shipinfos(mmsi), do: Repo.get(Shipinfos, mmsi)

  @doc """
  Creates a shipinfos.

  ## Examples

      iex> create_shipinfos(%{field: value})
      {:ok, %Shipinfos{}}

      iex> create_shipinfos(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_shipinfos(attrs \\ %{}) do
    %Shipinfos{}
    |> Shipinfos.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a shipinfos.

  ## Examples

      iex> update_shipinfos(shipinfos, %{field: new_value})
      {:ok, %Shipinfos{}}

      iex> update_shipinfos(shipinfos, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_shipinfos(%Shipinfos{} = shipinfos, attrs) do
    shipinfos
    |> Shipinfos.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a shipinfos.

  ## Examples

      iex> delete_shipinfos(shipinfos)
      {:ok, %Shipinfos{}}

      iex> delete_shipinfos(shipinfos)
      {:error, %Ecto.Changeset{}}

  """
  def delete_shipinfos(%Shipinfos{} = shipinfos) do
    Repo.delete(shipinfos)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking shipinfos changes.

  ## Examples

      iex> change_shipinfos(shipinfos)
      %Ecto.Changeset{data: %Shipinfos{}}

  """
  def change_shipinfos(%Shipinfos{} = shipinfos, attrs \\ %{}) do
    Shipinfos.changeset(shipinfos, attrs)
  end
end
