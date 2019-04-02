defmodule Ferry.Inventory do
  @moduledoc """
  The Inventory context.
  """

  import Ecto.Query, warn: false
  alias Ferry.Repo
  alias Ecto.Multi
  alias Ecto.Changeset

  alias Ferry.Profiles
  alias Ferry.Inventory.{
    Category,
    Item,
    Mod,
    Packaging,
    Stock
  }

  # Stock
  # ================================================================================
  # NOTE: Stocks are the primary way of interacting with the inventory
  #       management system. They expose public functions which govern creating,
  #       updating, and deleting other Inventory schemas.  Thus these functions
  #       should be defined privately at the end of this file, and tested
  #       through the Stock functions.
  #
  #       The general exception to this rule is getter functions which may be
  #       necessary to facilitate UI lists, forms, and search functionality.

  @doc """
  Returns the list of stocks.

  ## Examples

      iex> list_stocks()
      [%Stock{}, ...]

  """
  def list_stocks do
    Repo.all(Stock)
  end

  @doc """
  Gets a single stock.

  Raises `Ecto.NoResultsError` if the Stock does not exist.

  ## Examples

      iex> get_stock!(123)
      %Stock{}

      iex> get_stock!(456)
      ** (Ecto.NoResultsError)

  """
  def get_stock!(id) do
    query = from s in Stock,
      join: proj in assoc(s, :project),
      join: g in assoc(proj, :group),

      join: i in assoc(s, :item),
      join: c in assoc(i, :category),

      join: m in assoc(s, :mod),
      join: p in assoc(s, :packaging),

      preload: [
        project: {proj, group: g},
        item: {i, category: c},
        mod: m,
        packaging: p
      ]

    Repo.get!(query, id)
  end

  @doc """
  Creates a stock.

  ## Examples

      iex> create_stock(%{field: value})
      {:ok, %Stock{}}

      iex> create_stock(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  # TODO:  - virtual item matching direct input,
  #        - validate that all at once by combining all the other validations,
  #        - do that by running a special changeset on each schema which tests
  #          each field, but not dependencies which may not exist yet
  #        - if all the fields pass, all the dependencies should be met after
  #          retrieving them / creating them; throw a server error if they are
  #          not- DB errors will still be thrown, or they could be revalidated
  #          with dependencies a 2nd time before creation
  def create_stock(attrs \\ %{}) do
    {_, category} = get_or_create_category(attrs.item.category)
    {_, item} = get_or_create_item(category, attrs.item)
    {:ok, mod} = get_mod(attrs.mod)

    attrs = Map.merge(attrs, %{
      item: item,
      mod: mod,
    })

    %Stock{}
    |> Stock.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a stock.

  ## Examples

      iex> update_stock(stock, %{field: new_value})
      {:ok, %Stock{}}

      iex> update_stock(stock, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_stock(%Stock{} = stock, attrs) do
    {_, category} = get_or_create_category(attrs.item.category)
    {_, item} = get_or_create_item(category, attrs.item)
    {:ok, mod} = get_mod(attrs.mod)

    attrs = Map.merge(attrs, %{
      item: item,
      mod: mod,
    })

    stock
    |> Stock.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Stock.

  ## Examples

      iex> delete_stock(stock)
      {:ok, %Stock{}}

      iex> delete_stock(stock)
      {:error, %Ecto.Changeset{}}

  """
  def delete_stock(%Stock{} = stock) do
    Multi.new
    |> Multi.delete(:stock, stock)
    |> Multi.delete(:packaging, stock.packaging)
    |> Repo.transaction
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking stock changes.

  ## Examples

      iex> change_stock(stock)
      %Ecto.Changeset{source: %Stock{}}

  """
  def change_stock(%Stock{} = stock) do
    Stock.validate(stock)
  end


  # Category
  # ================================================================================

  defp get_or_create_category(attrs \\ %{}) do
    case Repo.get_by(Category, name: Map.get(attrs, :name)) do
      %Category{} = category ->
        {:ok, category}
      nil ->
        create_category(attrs)
    end
  end

  defp create_category(attrs \\ %{}) do
    %Category{}
    |> Category.changeset(attrs)
    |> Repo.insert()
  end


  # Item
  # ================================================================================
  
  defp get_or_create_item(category_or_changeset, attrs \\ %{})

  defp get_or_create_item(%Category{} = category, attrs) do
    item = Repo.one(from i in Item,
      where: i.name == ^attrs.name
         and i.category_id == ^category.id,
      join: c in assoc(i, :category),
      preload: [category: c]
    )

    case item do
      %Item{} -> {:ok, item}
      _ -> 
        %Item{}
        |> Item.changeset(%{attrs | category: category})
        |> Repo.insert()
    end
  end

  defp get_or_create_item(%Changeset{} = category_changeset, attrs) do
    changeset = %Item{}
    |> Item.changeset(%{attrs | category: category_changeset})
    {:error, changeset}
  end


  # Mod
  # ================================================================================

  defp get_mod(attrs \\ %{}) do
    query = from m in Mod

    filter_keys = [:gender, :age, :size, :season]
    query = Enum.reduce(filter_keys, query, fn key, query ->
      value = Map.get(attrs, key)
      if value != "" && value != nil do
        from m in query, where: field(m, ^key) == ^value
      else
        from m in query, where: is_nil field(m, ^key)
      end
    end)

    mod = Repo.one!(query)

    {:ok, mod} # standardize return with related Category & Item functions
  end
  

  # Packaging
  # ================================================================================
  # NOTE: Packaging data is managed alongside the Stock data for now, using
  #       `cast_assoc`.  Thus no need for a create / update / delete function.
end
