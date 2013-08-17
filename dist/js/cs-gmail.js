$(function() {
  console.log("I'm in GMail, and I have JQuery ho ho ho.");
  return chrome.runtime.sendMessage({
    status: 'ready'
  }, function(response) {
    return console.log("Server replied with response: " + response.message);
  });
});
