defmodule RobosseumWeb.LayoutView do
  use RobosseumWeb, :view

  def alerts(conn) do
    for {flash, message} <- get_flash(conn) do
      case flash do
        "info" -> notification("is-info", message)
        "alert" -> notification("is-danger", message)
      end
    end
  end

  defp notification(klass, message) do
    content_tag "p", message, class: "notification #{klass}"
  end
end
