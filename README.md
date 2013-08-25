tt.js
=====

This project contains all pieces that togehter builds up tt.js. To build tt.js on your local machine follow these steps:

    # Install node on your local machine
    $ brew install node
    
    # Globally install grunt
    $ npm install -g grunt
    
    # Install all dependencies
    $ npm install
    
    # Build tt.js using grunt
    $ grunt build
    
    # Upload the built assets to s3
    $ export AWS_ACCESS_KEY_ID="<key>"
    $ export AWS_SECRET_ACCESS_KEY="<secret>"
    $ grunt s3
