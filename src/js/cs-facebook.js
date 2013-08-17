$(document).ready(function(){

    setText = function (message){

        target = $("textarea")[0];
        target.value = message;
    
    };

    getText = function (){

        target = $("textarea")[0];
        return target.value;

    };

    getLastMessage = function (){

        ps = $("p");
        target = ps[ps.length - 1];
        return target.innerText;

    };

    chrome.runtime.onMessage.addListener(
      function(request, sender, sendResponse) {
          if (request.fonction && request.fonction === "retrieve"){
            sendResponse({status: "ok", text:getText()});
          } else if (request.fonction && request.fonction === "inject"){
            sendResponse({status: "ok"});
            setText(request.message);
          } else if (request.fonction && request.fonction === "retrieveLast"){
            sendResponse({status: "ok", text:getLastMessage()});
          }

    }); 

});

