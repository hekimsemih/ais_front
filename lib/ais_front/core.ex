defmodule AisFront.Core do
  @moduledoc """
  The Core context.
  """

  import Ecto.Query, warn: false
  alias AisFront.RepoBack, as: Repo

  alias AisFront.Core.Shipinfos
  alias AisFront.Core.Shiptype

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
  Returns the list of core_shipinfos with the associated type.

  ## Examples

      iex> list_shipinfos_with_type()
      [{%Shipinfos{}, %Shiptype{}}, ...]

  """
  def list_shipinfos_with_type do
    query = from(si in Shipinfos, join: st in Shiptype, on: st.type_id == si.ship_type, select: {si, st}), where: si.valid_position == true
    query |> Repo.all
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
  Gets a single shipinfos with its associated type.

  Raises `Ecto.NoResultsError` if the Ship infos does not exist.

  ## Examples

      iex> get_shipinfos!(123)
      {%Shipinfos{}, %Shiptype{}}

      iex> get_shipinfos!(456)
      ** (Ecto.NoResultsError)

  """
  def get_shipinfos_with_type!(mmsi) do
    query = from(si in Shipinfos, join: st in Shiptype, on: st.type_id == si.ship_type, select: {si, st}, where: si.mmsi == ^mmsi, where: si.valid_position == true)
    query |> Repo.all
  end

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

  alias AisFront.Core.Shiptype

  @doc """
  Returns the list of shiptypes.

  ## Examples

      iex> list_shiptypes()
      [%Shiptype{}, ...]

  """
  def list_shiptypes do
    Repo.all(Shiptype)
  end

  @doc """
  Gets a single shiptype.

  Raises `Ecto.NoResultsError` if the Shiptype does not exist.

  ## Examples

      iex> get_shiptype!(123)
      %Shiptype{}

      iex> get_shiptype!(456)
      ** (Ecto.NoResultsError)

  """
  def get_shiptype!(id), do: Repo.get!(Shiptype, id)

  @doc """
  Creates a shiptype.

  ## Examples

      iex> create_shiptype(%{field: value})
      {:ok, %Shiptype{}}

      iex> create_shiptype(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_shiptype(attrs \\ %{}) do
    %Shiptype{}
    |> Shiptype.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a shiptype.

  ## Examples

      iex> update_shiptype(shiptype, %{field: new_value})
      {:ok, %Shiptype{}}

      iex> update_shiptype(shiptype, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_shiptype(%Shiptype{} = shiptype, attrs) do
    shiptype
    |> Shiptype.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a shiptype.

  ## Examples

      iex> delete_shiptype(shiptype)
      {:ok, %Shiptype{}}

      iex> delete_shiptype(shiptype)
      {:error, %Ecto.Changeset{}}

  """
  def delete_shiptype(%Shiptype{} = shiptype) do
    Repo.delete(shiptype)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking shiptype changes.

  ## Examples

      iex> change_shiptype(shiptype)
      %Ecto.Changeset{data: %Shiptype{}}

  """
  def change_shiptype(%Shiptype{} = shiptype, attrs \\ %{}) do
    Shiptype.changeset(shiptype, attrs)
  end
end
