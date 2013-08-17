$ ->
  console.log "Loaded browser page"

  $('#button-import-textarea').click ()->
    console.log "Clicked text area"
    chrome.tabs.query {active:true, currentWindow:true}, (tabs) ->
      chrome.tabs.sendMessage tabs[0].id, {fonction: 'retrieve'}, (response)->
        console.log "response is"
        console.log response
        $('#popup-textarea').html response.text
        
  $('#button-decrypt').click ()->
    #TODO decrypt magic here
    cipherText = $('#popup-textarea').val()
    clearText = "This is clear like woah: #{cipherText}"
    $('#popup-textarea').val clearText
        
  $('#button-sign').click ()->
    plainText = $('#popup-textarea').val()

    #TODO replace signature strategy here
    cipherText = "====Signed message==== \n #{plainText} \n ==== End message ===="
    $('#popup-textarea').val(cipherText)
    
    #We send the content-script our new ciphertext
    chrome.tabs.query {active:true, currentWindow:true}, (tabs) ->
      chrome.tabs.sendMessage tabs[0].id, {fonction: 'inject', message: cipherText}, (response)->
        console.log "Listener replied with status #{response.status}"

  $('#button-encrypt').click ()->
    plainText = $('#popup-textarea').val()

    #TODO replace encryption strategy here
    cipherText = "shh, this is a secret: #{plainText}"
    $('#popup-textarea').val(cipherText)
    
    #We send the content-script our new ciphertext
    chrome.tabs.query {active:true, currentWindow:true}, (tabs) ->
      chrome.tabs.sendMessage tabs[0].id, {fonction: 'inject', message: cipherText}, (response)->
        console.log "Listener replied with status #{response.status}"

  $('#button-verify').click ()->
    console.log "Clicked verify"
    #TODO sign verif magic here
    signedText = $('#popup-textarea').val()
    signedConfirmation = "Cool, the text checks out \n ===== \n #{signedText}"
    $('#popup-textarea').val signedConfirmation
