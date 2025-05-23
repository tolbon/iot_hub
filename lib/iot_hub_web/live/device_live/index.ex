defmodule IotHubWeb.DeviceLive.Index do
  use IotHubWeb, :live_view

  alias IotHub.Devices
  alias IotHub.Devices.Device

  @impl true
  def mount(params, _session, socket) do
    hub_id = params["hub_id"];
    {:ok, socket
    |> assign(:hub_id, hub_id)
    |> stream(socket, :devices, Devices.list_devices_in_hub(hub_id))}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Device")
    |> assign(:device, Devices.get_device!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Device")
    |> assign(:device, %Device{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Devices")
    |> assign(:device, nil)
  end

  @impl true
  def handle_info({IotHubWeb.DeviceLive.FormComponent, {:saved, device}}, socket) do
    {:noreply, stream_insert(socket, :devices, device)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    device = Devices.get_device!(id)
    {:ok, _} = Devices.delete_device(device)

    {:noreply, stream_delete(socket, :devices, device)}
  end
end
