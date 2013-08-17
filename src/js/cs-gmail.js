function inject_text(message){

    // There could be many divs editable
    // Take the first one
    target = $("div[g_editable='true']")[0]
    target.text(message);

}

