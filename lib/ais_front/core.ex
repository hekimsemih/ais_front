defmodule AisFront.Core do
  @moduledoc """
  The Core context.
  """

  import Ecto.Query, warn: false
  alias AisFront.RepoBack, as: Repo

  alias AisFront.Core.Shipinfos
  alias AisFront.Core.Shiptype

  defp sanitize_identifier(identifier) do
    identifier
    |> String.replace(["%", "_", "\\"], fn c -> "\\#{c}" end)
  end

  @doc """
  Returns at most limit ship_full infos where identifier is in one of the ship
  ids (mmsi, callsign or name)
  """
  def get_ships_by_identifiers(identifier, limit \\ 10) do
    id_str = "%#{sanitize_identifier(identifier)}%"
    from(
      si in Shipinfos,
      join: st in Shiptype,
      on: st.type_id == si.ship_type,
      where: si.valid_position == true and (
        like(type(si.mmsi, :string), ^id_str)
        or ilike(si.callsign, ^id_str)
        or ilike(si.name, ^id_str)
      ),
      limit: ^limit)
      |> select([si, st], %{
        mmsi: si.mmsi,
        callsign: si.callsign,
        cog: si.cog,
        destination: si.destination,
        dim_bow: si.dim_bow,
        dim_port: si.dim_port,
        dim_starboard: si.dim_starboard,
        dim_stern: si.dim_stern,
        draught: si.draught,
        eta: si.eta,
        heading: si.heading,
        imo: si.imo,
        name: si.name,
        navstat: si.navstat,
        pac: si.pac,
        point: si.point,
        rot: si.rot,
        ship_type: si.ship_type,
        sog: si.sog,
        time: si.time,
        valid_position: si.valid_position,

        type_short_name: st.short_name,
        type_name: st.name,
        type_summary: st.summary,
        type_details: st.details
      })
      |> Repo.all
  end

  @doc """
  Returns the list of core_shipinfos.

  ## Examples

      iex> list_shipinfos()
      [%Shipinfos{}, ...]

  """
  def list_shipinfos do
    Repo.all(Shipinfos)
  end

  defp query_full do
    from(
      si in Shipinfos,
      join: st in Shiptype,
      on: st.type_id == si.ship_type,
      where: si.valid_position == true
      )
  end
  @doc """
  Returns the list of core_shipinfos with the full informations.

  ## Examples

      iex> list_shipinfos_full()
      [{%Shipinfos{}, %Shiptype{}}, ...]

  """
  def list_shipinfos_full do
    query_full()
    |> select([si, st], %{
      mmsi: si.mmsi,
      callsign: si.callsign,
      cog: si.cog,
      destination: si.destination,
      dim_bow: si.dim_bow,
      dim_port: si.dim_port,
      dim_starboard: si.dim_starboard,
      dim_stern: si.dim_stern,
      draught: si.draught,
      eta: si.eta,
      heading: si.heading,
      imo: si.imo,
      name: si.name,
      navstat: si.navstat,
      pac: si.pac,
      point: si.point,
      rot: si.rot,
      ship_type: si.ship_type,
      sog: si.sog,
      time: si.time,
      valid_position: si.valid_position,

      type_short_name: st.short_name,
      type_name: st.name,
      type_summary: st.summary,
      type_details: st.details
    })
    |> Repo.all
    # |> Enum.map(fn infos ->
    #   Enum.reduce(infos, %{}, fn val, acc ->
    #     val
    #     |> Map.to_list
    #     |> Enum.filter(fn {k, _v} ->
    #       k not in [:__struct__, :__meta__]
    #     end)
    #     |> Enum.into(acc)
    #   end)
    # end)
  end

  def list_shipinfos_large_map do
    query_full()
    |> select(
      [si, st],
      %{
        mmsi: si.mmsi,
        time: si.time,
        point: si.point,
        callsign: si.callsign,
        name: si.name,
        sog: si.sog,
        cog: si.cog,
        heading: si.heading,

        type: st.short_name
      }
    )
    |> where([si, st], si.time > datetime_add(^DateTime.utc_now(), -5, "minute"))
    |> Repo.all
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

  def get_shipinfos_full(mmsi) do
    query_full()
    |> where([si, st], si.mmsi == ^mmsi)
    |> select([si, st], %{
      mmsi: si.mmsi,
      callsign: si.callsign,
      cog: si.cog,
      destination: si.destination,
      dim_bow: si.dim_bow,
      dim_port: si.dim_port,
      dim_starboard: si.dim_starboard,
      dim_stern: si.dim_stern,
      draught: si.draught,
      eta: si.eta,
      heading: si.heading,
      imo: si.imo,
      name: si.name,
      navstat: si.navstat,
      pac: si.pac,
      point: si.point,
      rot: si.rot,
      ship_type: si.ship_type,
      sog: si.sog,
      time: si.time,
      valid_position: si.valid_position,

      type_short_name: st.short_name,
      type_name: st.name,
      type_summary: st.summary,
      type_details: st.details
    })
    |> Repo.one
  end

  def get_shipinfos_large_map(mmsi) do
    query_full()
    |> where([si, st], si.mmsi == ^mmsi)
    |> select(
      [si, st],
      %{
        mmsi: si.mmsi,
        time: si.time,
        point: si.point,
        callsign: si.callsign,
        name: si.name,
        sog: si.sog,
        cog: si.cog,
        heading: si.heading,

        type: st.short_name
      }
    )
    |> Repo.one
  end

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
