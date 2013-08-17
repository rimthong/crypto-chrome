$(document).ready(function(){

    setText = function (message){
    
        // There could be many divs editable
        // Take the first one
        target = $("div[g_editable='true']")[0];
        target.innerText = message;

    };

    getText = function (){

        target = $("div[g_editable='true']")[0];
        if (!target.innerText ){
            return target.text();
        }
        return target.innerText;

    };

    getLastMessage = function (){

        target = $("div[style='overflow: hidden;']").children()[0];
        if (!target.innerText ){
            return target.text();
        }
        return target.innerText;

    };

    getLastSender = function (){

        targets = $('span[class="go"]');
        target = targets[targets.length - 1];
        return target.innerText.replace('<','').replace('>','');

    };

    chrome.runtime.onMessage.addListener(
      function(request, sender, sendResponse) {
          if (request.fonction && request.fonction === "retrieve"){
            sendResponse({status: "ok", text:getText()});
          } else if (request.fonction && request.fonction === "inject"){
            sendResponse({status: "ok"});
            setText(request.message);
          } else if (request.fonction && request.fonction === "retrieveLast"){
            sendResponse({status: "ok", text:getLastMessage(), sender:getLastSender()});
          }

    }); 

});

