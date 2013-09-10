module.exports = (grunt) ->
  require('matchdep').filterDev('grunt-*').forEach(grunt.loadNpmTasks)

  grunt.initConfig
    pkg: grunt.file.readJSON('package.json')

    config:
      build: 'build'

    coffee:
      build:
        expand: true,
        cwd: 'src',
        src: '{,*/}*.coffee',
        dest: '<%= config.build %>',
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
