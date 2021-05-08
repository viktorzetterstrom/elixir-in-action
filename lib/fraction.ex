defmodule Fraction do
  defstruct a: nil, b: nil

  @spec new(number, number) :: %Fraction{}
  def new(a, b), do: %Fraction{a: a, b: b}

  @spec value(%Fraction{}) :: float
  def value(%Fraction{a: a, b: b}), do: a / b

  @spec add(%Fraction{}, %Fraction{}) :: %Fraction{}
  def add(%Fraction{a: a1, b: b1}, %Fraction{a: a2, b: b2}) do
    new(
      a1 * b2 + a2 * b1,
      b1 * b2
    )
  end
end
