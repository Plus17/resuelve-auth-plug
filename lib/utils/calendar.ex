defmodule ResuelveAuth.Utils.Calendar do
  @moduledoc """
  Encapsula las funciones relacionadas con la fecha.
  Si se requiere usar alguna biblioteca de tiempo, aquí debe agregarse
  la funcionalidad deseada y en el proyecto solo se deben encontrar
  llamadas al módulo de Calendar para facilitar el mantenimiento del código.
  """

  @time_units :millisecond

  @doc """
  Identifica si la fecha enviada como Unix time es pasada.
  En caso de mandar un valor que no sea entero, regresa `true` por defecto.

  ## Ejemplos

  ```elixir

     iex> alias ResuelveAuth.Utils.Calendar
     iex> unix_time = 1572617244
     iex> Calendar.is_past?(unix_time)
     true

     iex> alias ResuelveAuth.Utils.Calendar
     iex> unix_time = 4128685709000
     iex> Calendar.is_past?(unix_time)
     false

     iex> alias ResuelveAuth.Utils.Calendar
     iex> Calendar.is_past?("2100-02-29T12:30:30+00:00")
     true

  ```

  """
  @spec is_past?(integer()) :: boolean()
  def is_past?(unix_time) when is_integer(unix_time) do
    unix_time
    |> Timex.from_unix(@time_units)
    |> is_past?()
  end

  def is_past?(%DateTime{} = datetime) do
    Timex.before?(datetime, Timex.now())
  end

  def is_past?(_input), do: true

  @doc """
  Agrega el número de horas enviado a la fecha proporcionada.

  ## Ejemplos

  ```elixir

     iex> {:ok, datetime} = DateTime.from_unix(0)
     iex> limit_time = ResuelveAuth.Utils.Calendar.add(datetime, 2, :hour)
     iex> {:ok, expected, 0} = DateTime.from_iso8601("1970-01-01 02:00:00Z")
     iex> DateTime.compare(limit_time, expected)
     :eq

     iex> timestamp = 4128685709000
     iex> limit_time = ResuelveAuth.Utils.Calendar.add(timestamp, 2, :hour)
     iex> {:ok, expected, 0} = DateTime.from_iso8601("2100-10-31 19:08:29.000Z")
     iex> DateTime.compare(limit_time, expected)
     :eq

  ```

  """
  def add(%DateTime{} = datetime, hours, :hour) do
    Timex.shift(datetime, hours: hours)
  end

  def add(unix_time, hours, :hour) when is_integer(unix_time) do
    unix_time
    |> Timex.from_unix(@time_units)
    |> add(hours, :hour)
  end

  def add(_non_time, _hours, :hour), do: {:error, :invalid_time}
end
