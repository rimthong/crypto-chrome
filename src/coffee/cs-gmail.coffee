$ ->

  getText = ()->
     $("div[g_editable='true']").innerText ||  $("div[g_editable='true']").text()

  setText = (message)->
    $("div[g_editable='true']").innerText = message

  getLastMessage = ()->
    $("div[style='overflow: hidden;']").children[0]

  chrome.runtime.onMessage.addListener (request, sender, sendResponse) ->
    if request.fonction and request.fonction is 'retrieve'
      sendResponse({status:ok, text:getText()})
    if request.fonction and request.fonction is 'inject'
      sendResponse({status:ok})
      setText request.message
    if request.fonction and request.fonction is 'retrieveLast'
      sendResponse({status:ok, text:getLastText()})
