defmodule BlogPhoenix.Post do
  use BlogPhoenix.Web, :model
  import Ecto.Query

  schema "posts" do
    field :title, :string
    field :body, :string

    has_many :comments, BlogPhoenix.Comment

    timestamps
  end

  @required_fields ~w(title body)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If `params` are nil, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end

  def count_comments(query) do
    from p in query,
      group_by: p.id,
      left_join: c in assoc(p, :comments),
      select: {p, count(c.id)}
  end

end
