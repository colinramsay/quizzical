defmodule Quizzical.LiveHelpers do
  import Phoenix.LiveView

  def assign_defaults(socket, %{"user_token" => user_token}) do
    #    socket =
    assign(socket, current_user: Quizzical.Accounts.get_user_by_session_token(user_token))

    # if socket.assigns.current_user.confirmed_at do
    #   socket
    # else
    #   redirect(socket, to: "/login")
    # end
  end

  def assign_defaults(socket, _session) do
    assign(socket, current_user: nil)
  end
end
