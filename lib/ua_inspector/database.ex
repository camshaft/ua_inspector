defmodule UAInspector.Database do
  @moduledoc """
  Basic database module providing minimal functions.
  """

  defmacro __using__(_opts) do
    quote do
      @before_compile unquote(__MODULE__)

      @behaviour unquote(__MODULE__)
    end
  end

  defmacro __before_compile__(_env) do
    quote do
      def init() do
        :ok
      end

      def list,    do: __MODULE__.DB.list()
      def sources, do: @sources

      def load(path) do
        @sources
        |> Enum.flat_map(fn({type, local, _remote}) ->
          database = Path.join(path, local)

          if File.regular?(database) do
            database
            |> unquote(__MODULE__).load_database()
            |> parse_database(type, [])
          else
            []
          end
        end)
        |> UAInspector.Database.compile(__ENV__)

        :ok
      end

      def parse_database([],                  _type, acc), do: :lists.reverse(acc)
      def parse_database([ entry | database ], type, acc)  do
        entry = store_entry(entry, type)
        parse_database(database, type, [entry | acc])
      end
    end
  end

  @doc """
  Initializes (sets up) the database.
  """
  @callback init() :: atom | :ets.tid

  @doc """
  Returns all database entries as a list.
  """
  @callback list() :: list

  @doc """
  Loads a database file.
  """
  @callback load(path :: String.t) :: :ok

  @doc """
  Traverses the database and passes each entry to the storage function.
  """
  @callback parse_database(entries :: list, type :: String.t, []) :: :ok

  @doc """
  Returns the database sources.
  """
  @callback sources() :: list

  @doc """
  Stores a database entry.

  If necessary a data conversion is made from the raw data passed
  directly out of the database file and the actual data needed when
  querying the database.
  """
  @callback store_entry(entry :: any, type :: String.t) :: boolean

  @doc """
  Parses a yaml database file and returns the contents.
  """
  @spec load_database(String.t) :: any
  def load_database(file) do
    file
    |> to_char_list()
    |> :yamerl_constr.file([ :str_node_as_binary ])
    |> hd()
  end

  def compile(entries, env) do
    filename = env.file |> to_char_list()
    module = Module.concat(env.module, DB)
    entries
    |> to_forms(module)
    |> to_beam(filename)
    |> load_beam(filename)
  end

  defp to_forms(entries, mod) do
    [
      {:attribute, 1, :module, mod},
      {:attribute, 2, :export, [list: 0]},
      {:function, 3, :list, 0, [
        {:clause, 3, [], [], [:erl_parse.abstract(entries)]}
      ]}
    ]
  end

  defp to_beam(forms, filename) do
    forms
    |> :compile.forms([
      :binary,
      :report_errors,
      {:source, filename},
      :no_error_module_mismatch
    ])
  end

  defp load_beam({:ok, mod, bin}, filename) do
    {:module, ^mod} = :code.load_binary(mod, filename, bin)
  end
end
