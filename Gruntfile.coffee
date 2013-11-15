module.exports = (grunt) ->
  require('matchdep').filterDev('grunt-*').forEach(grunt.loadNpmTasks)

  grunt.initConfig
    pkg: grunt.file.readJSON('package.json')

    config:
      src: 'src'
      test: 'test'
      build: 'build'
      tmp: '.tmp'
      docs: '.tmp/docs'

    coffee:
      test:
        expand: true
        src: 'test/{,*/}*.coffee'
        dest: '<%= config.tmp %>'
        ext: '.js'

      build:
        expand: true
        src: 'src/{,*/}*.coffee'
        dest: '<%= config.tmp %>'
        ext: '.js'

    s3:
      options:
        bucket: 'sdk.ttcdn.co'
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
      docs:
        src: ['<%= config.docs %>/classes/*.html', '!<%= config.docs %>/classes/TT.api.html', '<%= config.docs %>/classes/TT.api.html']
        dest: '<%= config.build %>/tt.js.docs.html'

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

    browserify:
      tt:
        src: ['<%= config.tmp %>/src/tt.js']
        dest: '<%= config.build %>/tt.js'

      api:
        src: ['<%= config.tmp %>/src/tt-api.js']
        dest: '<%= config.build %>/tt-api.js'

      native:
        src: ['<%= config.tmp %>/src/tt-native.js']
        dest: '<%= config.build %>/tt-native.js'

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
          themedir: 'docs/theme'
          outdir: '<%= config.docs %>'


  grunt.registerTask 'build', [
    'clean:build'
    'coffee:build'
    'browserify'
    'copy:build'
  ]

  grunt.registerTask 'release', [
    'build'
    'docs'
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
    'concat:docs'
    'copy:build'
  ]
