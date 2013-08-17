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



});

