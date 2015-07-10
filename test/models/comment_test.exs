defmodule BlogPhoenix.CommentTest do
  use BlogPhoenix.ModelCase

  alias BlogPhoenix.Comment

  @valid_attrs %{content: "some content", name: "some content", post: nil}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Comment.changeset(%Comment{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Comment.changeset(%Comment{}, @invalid_attrs)
    refute changeset.valid?
  end
end
