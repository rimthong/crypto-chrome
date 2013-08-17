$(document).ready(function(){

    setText = function (message){
    
        // There could be many divs editable
        // Take the first one
        target = $("div[g_editable='true']")[0];
        target.innerText = message;

    };

    getText = function (){

        target = $("div[g_editable='true']")[0];
        return target.innerText;

    };

    chrome.runtime.onMessage.addListener(
      function(request, sender, sendResponse) {
          if (request.fonction && request.fonction === "retrieve"){
            sendResponse({status: "ok", text:getText()});
          } else if (request.fonction && request.fonction === "inject"){
            sendResponse({status: "ok"});
            setText(request.message);
          }
    }); 

});

