chrome.runtime.onMessage.addListener (request, sender, sendResponse)->
  if request.status is 'ready'
    sendResponse {message: 'ready, gold leader!'}
