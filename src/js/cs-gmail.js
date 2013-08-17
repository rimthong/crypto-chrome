inject_text = function (message){

    // There could be many divs editable
    // Take the first one
    target = $("div[g_editable='true']")[0];
    target.innerText = message;

};

