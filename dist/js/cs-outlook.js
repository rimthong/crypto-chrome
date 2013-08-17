$(document).ready(function(){

    setText = function (message){

        target = $("#ComposeRteEditor");
        target.text(message);

    };

    getText = function (){

        target = $("#ComposeRteEditor");
        return target.text();

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


