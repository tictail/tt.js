module.exports = (grunt) ->
  require('matchdep').filterDev('grunt-*').forEach(grunt.loadNpmTasks)

  grunt.initConfig
    pkg: grunt.file.readJSON('package.json')

    config:
      src: 'src'
      test: 'test'
      build: 'build'
      tmp: '.tmp'

    coffee:
      test:
        expand: true
        src: '{,*/}*.coffee'
        dest: '<%= config.tmp %>'
        ext: '.js'

      build:
        expand: true
        cwd: '<%= config.src %>'
        src: '{,*/}*.coffee'
        dest: '<%= config.build %>'
        ext: '.js'

    s3:
      options:
        bucket: 'com.tictail.cdn.apps.assets'
        region: 'eu-west-1'
        access: 'public-read'

      build:
        upload: [
          src: "<%= config.build %>/*"
          dest: ""
        ]

    bump:
      options:
        pushTo: "origin"

    clean:
      build:
        files: [{
          dot: true
          src: [
            '<%= config.build %>/*'
          ]
        }]

    copy:
      build:
        files: [{
          expand: true,
          cwd: '<%= config.build %>'
          src: [
            '**.*'
          ]
          dest: '<%= config.build %>/'
          filter: (src) ->
            return not src.match(/\d+\.\d+\.\d+/)
          rename: (dest, src) ->
            parts = src.split(".")
            extension = parts.pop()
            parts.push('<%= pkg.version %>')
            parts.push(extension)
            dest + parts.join(".")
        }]

    concat:
      options:
        banner: "/*! v<%= pkg.version %> - <%= grunt.template.today('yyyy-mm-dd') %> */\n\n",

      build:
        src: '<%= config.build %>/*.js'
        dest: '<%= config.build %>/tt.js'

    connect:
      test:
        options:
          port: 9000
          base: [
            '<%= config.test %>'
            '<%= config.tmp %>'
            '<%= config.build %>'
            'node_modules'
          ]

    watch:
      test:
        files: [
          '<%= config.test %>/{,*/}*.coffee'
          '<%= config.src %>/{,*/}*.coffee'
          'test/index.html'
        ]
        tasks: [
          'test'
        ]

    mocha:
      all:
        options:
          run: true
          bail: false
          log: true
          reporter: 'Spec'
          urls: ['http://127.0.0.1:9000/index.html']

    yuidoc:
      compile:
        name: '<%= pkg.name %>'
        description: '<%= pkg.description %>'
        version: '<%= pkg.version %>'
        url: '<%= pkg.homepage %>'
        options:
          paths: 'src'
          syntaxtype: "coffee"
          extension: ".coffee"
          themedir: 'theme'
          outdir: 'docs'


  grunt.registerTask 'build', [
    'clean:build'
    'coffee:build'
    'concat:build'
    'copy:build'
  ]

  grunt.registerTask 'release', [
    'build'
    's3'
  ]

  grunt.registerTask 'test', [
    'build'
    'coffee:test'
    'connect:test'
    'mocha'
  ]

  grunt.registerTask 'docs', [
    'yuidoc:compile'
  ]
