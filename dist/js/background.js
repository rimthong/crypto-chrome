chrome.runtime.onMessage.addListener(function(request, sender, sendResponse) {
  if (request.status === 'ready') {
    return sendResponse({
      message: 'ready, gold leader!'
    });
  }
});
