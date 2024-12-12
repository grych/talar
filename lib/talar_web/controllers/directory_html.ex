defmodule TalarWeb.DirectoryHTML do
  use TalarWeb, :html

  embed_templates "directory_html/*"

  @doc """
  Renders a directory form.
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true

  def directory_form(assigns)
end
