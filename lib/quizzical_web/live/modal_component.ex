defmodule QuizzicalWeb.ModalComponent do
  use QuizzicalWeb, :live_component

  @impl true
  def render(assigns) do
    ~L"""
      <div class="fixed z-10 inset-0 overflow-y-auto"
          id="<%= @id %>"
          phx-capture-click="close"
          phx-window-keydown="close"
          phx-key="escape"
          phx-target="#<%= @id %>"
          phx-page-loading>
        <div class="flex items-end justify-center min-h-screen pt-4 px-4 pb-20 text-center sm:block sm:p-0">
            <div class="fixed inset-0 transition-opacity" aria-hidden="true">
            <div class="absolute inset-0 bg-gray-500 opacity-75"></div>
          </div>

          <!-- This element is to trick the browser into centering the modal contents. -->
          <span class="hidden sm:inline-block sm:align-middle sm:h-screen" aria-hidden="true">&#8203;</span>

          <div class="inline-block bg-white align-bottom bg-white rounded-lg text-left overflow-hidden shadow-xl transform transition-all sm:my-8 sm:align-middle sm:max-w-lg sm:w-full" role="dialog" aria-modal="true" aria-labelledby="modal-headline">
            <%= live_component @socket, @component, @opts %>
          </div>
        </div>
      </div>
    """
  end

  @impl true
  def handle_event("close", _, socket) do
    {:noreply, push_patch(socket, to: socket.assigns.return_to)}
  end
end
