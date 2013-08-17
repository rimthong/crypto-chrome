$(document).ready(function(){

    setText = function (message){

        target = $("textarea")[0];
        target.value = message;
    
    };

    getText = function (){

        target = $("textarea")[0];
        return target.value;

    };

    chrome.runtime.onMessage.addListener(
      function(request, sender, sendResponse) {
          if (request.fonction && request.fonction === "inject"){
            sendResponse({status: "ok"});
            setText(request.message);
          }
    }); 

    chrome.runtime.onMessage.addListener(
      function(request, sender, sendResponse) {
          if (request.fonction && request.fonction === "retrieve"){
            sendResponse({status: "ok", text:getText()});
          }
    }); 


});

