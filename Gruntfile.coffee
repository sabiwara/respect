module.exports = (grunt) ->

  # Project configuration.
  grunt.initConfig
    coffee:
      app:
        expand: true
        cwd: 'src'
        src: ['**/*.coffee']
        dest: 'lib'
        ext: '.js'

    watch:
      app:
        files: ['src/**/*.coffee']
        tasks: ['coffee']

    coffeelint:
      app: ['src/**/*.coffee']
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
        'pre-commit': 'check'

  # LOAD
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-uglify'
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
  grunt.registerTask 'hook', 'githooks'
