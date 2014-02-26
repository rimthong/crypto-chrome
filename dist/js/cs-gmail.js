$(function() {
  var getLastMessage, getText, setText;
  getText = function() {
    return $("div[g_editable='true']").innerText ||  ($("div[g_editable='true']").text());
  };
  setText = function(message) {
    return $("div[g_editable='true']").innerText = message;
  };
  getLastMessage = function() {
    return $("div[style='overflow: hidden;']").children[0];
  };
  return chrome.runtime.onMessage.addListener(function(request, sender, sendResponse) {
    if (request.fonction && request.fonction === 'retrieve') {
      sendResponse({
        status: ok,
        text: getText()
      });
    }
    if (request.fonction && request.fonction === 'inject') {
      sendResponse({
        status: ok
      });
      setText(request.message);
    }
    if (request.fonction && request.fonction === 'retrieveLast') {
      return sendResponse({
        status: ok,
        text: getLastText()
      });
    }
  });
});
