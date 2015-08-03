defmodule BlogPhoenix.PostController do
  use BlogPhoenix.Web, :controller

  alias BlogPhoenix.Post
  alias BlogPhoenix.Comment

  plug :scrub_params, "post" when action in [:create, :update]
  plug :scrub_params, "comment" when action in [:add_comment]

  def index(conn, _params) do
    posts = Post
    |> Post.count_comments
    |> Repo.all
    render(conn, "index.html", posts: posts)
  end

  def new(conn, _params) do
    changeset = Post.changeset(%Post{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"post" => post_params}) do
    changeset = Post.changeset(%Post{}, post_params)

    if changeset.valid? do
      Repo.insert(changeset)

      conn
      |> put_flash(:info, "Post created successfully.")
      |> redirect(to: post_path(conn, :index))
    else
      render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    post = Repo.get(Post, id) |> Repo.preload([:comments])
    changeset = Comment.changeset(%Comment{})
    render(conn, "show.html", post: post, changeset: changeset)
  end

  def edit(conn, %{"id" => id}) do
    post = Repo.get(Post, id)
    changeset = Post.changeset(post)
    render(conn, "edit.html", post: post, changeset: changeset)
  end

  def update(conn, %{"id" => id, "post" => post_params}) do
    post = Repo.get(Post, id)
    changeset = Post.changeset(post, post_params)

    if changeset.valid? do
      Repo.update(changeset)

      conn
      |> put_flash(:info, "Post updated successfully.")
      |> redirect(to: post_path(conn, :index))
    else
      render(conn, "edit.html", post: post, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    post = Repo.get(Post, id)
    Repo.delete(post)

    conn
    |> put_flash(:info, "Post deleted successfully.")
    |> redirect(to: post_path(conn, :index))
  end

  def add_comment(conn, %{"comment" => comment_params, "post_id" => post_id}) do
    changeset = Comment.changeset(%Comment{}, Map.put(comment_params, "post_id", post_id))
    post = Repo.get(Post, post_id) |> Repo.preload([:comments])

    if changeset.valid? do
      Repo.insert(changeset)

      conn
      |> put_flash(:info, "Comment added.")
      |> redirect(to: post_path(conn, :show, post))
    else
      render(conn, "show.html", post: post, changeset: changeset)
    end
  end
end
