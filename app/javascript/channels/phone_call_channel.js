import consumer from "./consumer"

consumer.subscriptions.create("PhoneCallChannel", {
  connected() {
    // Called when the subscription is ready for use on the server
    console.log("PhoneCallChannel: connected");
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
    console.log("PhoneCallChannel: disconnected");
  },

  received(data) {
    // Called when there's incoming data on the websocket for this channel
    console.log("PhoneCallChannel: received");
    $("#phone_calls").html(data);
  }
});
