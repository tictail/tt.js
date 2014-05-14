# TT.js


TT.js is our helper library that is used in Tictail Native Apps. The full documentation is available on our [developer page](https://tictail.com/developers/tt-js/). 

## Dependencies

To start out, you'll need to have both `node` and `npm` installed on your system. The rest of the dependencies are installed using `npm`:

```
# Globally install Grunt
$ npm install -g grunt

# Install all project dependencies
$ npm install
```

## Developing

The library is composed of modules that are all packaged together with Browserify. To build the .js files, use:

```
$ grunt build
```

## Testing

The *tests/* folder contains tests for the different parts of the library. To run them, use one of the following Grunt tasks:

```
# Run the tests once
$ grunt test

# Continuously run the tests during development
$ grunt watch
```

## Contributing

We appreciate both code contributions through [pull requests](https://github.com/tictail/tt.js/pulls) and feature requests / bug reports through [issues](https://github.com/tictail/tt.js/issues). Thank you for caring! 
