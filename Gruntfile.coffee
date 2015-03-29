module.exports = (grunt) ->

  # Project configuration.
  grunt.initConfig

    pkg: grunt.file.readJSON 'package.json'

    coffee:
      respect:
        expand: true
        cwd: 'src'
        src: ['**/*.coffee']
        dest: 'lib'
        ext: '.js'

    browserify:
      respect:
        options:
          browserifyOptions:
            standalone: 'respect'
        src: ['./lib/respect.js']
        dest: './respect.js'

    uglify:
      respect:
        options:
          banner: '/*! <%= pkg.name %>.js by <%= pkg.author %> MIT license */\n'
        files:
          'respect.min.js': ['respect.js']

    watch:
      respect:
        files: ['src/**/*.coffee']
        tasks: ['coffee', 'browserify', 'uglify']

    coffeelint:
      respect: ['src/**/*.coffee']
      test: ['test/**/*.coffee']
      options:
        configFile: 'coffeelint.json'

    mochacov:
      test:
        src: ['test/**/*.test.coffee'],
        options:
          recursive: true,
          reporter: 'spec'
          require: ['test/common']
          compilers: ['coffee:coffee-script/register']

    githooks:
      all:
        'pre-commit': 'pre-commit'

  # LOAD
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-uglify'
  grunt.loadNpmTasks 'grunt-browserify'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-coffeelint'
  grunt.loadNpmTasks 'grunt-mocha-cov'
  grunt.loadNpmTasks 'grunt-githooks'

  # REGISTER
  grunt.registerTask 'compile', ['coffee']
  grunt.registerTask 'default', 'compile'
  grunt.registerTask 'lint', 'coffeelint'
  grunt.registerTask 'test', 'mochacov:test'
  grunt.registerTask 'check', ['compile', 'coffeelint', 'test']
  grunt.registerTask 'browser', ['browserify', 'uglify']
  grunt.registerTask 'pre-commit', ['check', 'browser']
  grunt.registerTask 'hook', 'githooks'
