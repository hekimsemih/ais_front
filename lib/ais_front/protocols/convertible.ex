defprotocol AisFront.Protocols.Convertible do
@moduledoc """
Protocol to convert unit into its various possible unit representation
"""
  @type t :: Convertible.t()
  @type possible_unit :: atom

  @doc """
  Return the list of possible units
  """
  @spec possible_units(t()) :: list(possible_unit())
  def possible_units(t)

  @doc """
  Get the SI unit
  """
  @spec si_unit(t()) :: possible_unit()
  def si_unit(t)
  @doc """
  Test if current unit is the SI unit
  """
  @spec si?(t()) :: boolean
  def si?(t)
  @doc """
  Convert current unit to the SI unit
  """
  @spec to_si(t()) :: t()
  def to_si(t)

  @doc """
  Convert current unit to the specified possible unit
  """
  @spec convert(t(), possible_unit()) :: t()
  def convert(t, possible_unit)
end
