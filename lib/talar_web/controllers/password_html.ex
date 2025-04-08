defmodule TalarWeb.PasswordHTML do
  use TalarWeb, :html

  embed_templates "password_html/*"

  @doc """
  Renders a password form.
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true

  def password_form(assigns)
end
