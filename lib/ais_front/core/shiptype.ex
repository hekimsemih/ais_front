defmodule AisFront.Core.Shiptype do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:type_id, :integer, autogenerate: false}
  schema "core_shiptype" do
    field :details, :string
    field :name, :string
    field :short_name, :string
    field :summary, :string
  end

  @doc false
  def changeset(shiptype, attrs) do
    shiptype
    |> cast(attrs, [:type_id, :short_name, :name, :summary, :details])
    |> validate_required([:type_id, :short_name, :name, :summary, :details])
  end
end
