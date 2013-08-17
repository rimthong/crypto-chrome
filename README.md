crypto-chrome
============

build deps
----------
  * Node
  * npm
  * npm install -g grunt-cli

install
---------
Load unpacked extension from /dist directory.

usage
--------
  * start off with the **options** page, you will be prompted to enter a master password to encrypt keystore
  * go ahead and add your private keys and public keys (key generation coming soon)
  * a browser action will be available, a little lock in your toolbar, click it to use crypto-chrome
  * fill the textbox with your text, and you can use the **encrypt** and **sign** buttons
  * you can also paste an encrypted message in the box and use **decrypt**
  * we've built integration with GMail and Facebook, you can use the **import from page** and **import last message** options
  * in integrated page, **encrypt** and **sign** should inject text in your reply box (has to be open)
