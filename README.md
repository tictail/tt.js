tt.js
=====

This project contains all pieces that togehter builds up `tt.js`. Here are a few commands to get you started:

    # Install node on your local machine
    $ brew install node
    
    # Globally install grunt
    $ npm install -g grunt
    
    # Install all dependencies
    $ npm install
    
    # Build the assets during development
    $ grunt build
    
    # Run the tests during development
    $ grunt test
    
    # When you're ready to release a new version. Bump the version number,
    # tag a new release and push the code to GitHub
    $ grunt bump
    
    # Build and upload the assets to s3
    $ export AWS_ACCESS_KEY_ID="<key>"
    $ export AWS_SECRET_ACCESS_KEY="<secret>"
    $ grunt release
    
Have a look in the `Gruntfile.coffee` to get more information on what each step actually does.
