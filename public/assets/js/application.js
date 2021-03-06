var scheme   = "wss://";
var uri      = scheme + window.document.location.host + "/";
var ws       = new WebSocket(uri);

//Reception d'un message
ws.onmessage = function(message) {
  var data = JSON.parse(message.data);
  $("#chat-text").append("<p><strong>"+ data.handle +" : </strong>"+ data.text);
  $("#chat-text").stop().animate({
    scrollTop: $('#chat-text')[0].scrollHeight
  }, 800);
};

//Envopi d'un message
$("#input-form").on("submit", function(event) {
  event.preventDefault();
  var handle = $("#input-handle")[0].value;
  var text   = $("#input-text")[0].value;
  ws.send(JSON.stringify({ handle: handle, text: text }));
  $("#input-text")[0].value = "";
});