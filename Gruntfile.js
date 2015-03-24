module.exports = function(grunt) {
  var libSrc = 'lib/*.coffee';
  var libComp = 'lib/lib.js';
  var testSrc = 'test/*.coffee';
  var testComp = 'test/test.js';

  var config = {
    clean: [libComp, testComp],
    coffee: {
      compile: {
        options: {
          bare: true,
          join: true
        },
        files: {
          'lib/lib.js': libSrc,
          'test/test.js': testSrc
        }
      }
    },
    coffeelint: {
      all: [libSrc, testSrc],
      options: {
        no_unnecessary_double_quotes: "error",
        no_interpolation_in_single_quotes: "error",
        prefer_english_operator: "error"
      }
    },
    mochaTest: {
      test: {
        options: {
          reporter: 'spec',
          captureFile: 'results.txt', // Optionally capture the reporter output to a file
          quiet: false, // Optionally suppress output to standard out (defaults to false)
          clearRequireCache: true // needed to run from 'watch'
        },
        src: [testComp]
      }
    },
    jshint: {
      all: ['Gruntfile.js']
    },
    watch: {
      files: [libSrc, testSrc, 'Gruntfile.js', 'package.json'],
      tasks: ['test']
    }
  };
  grunt.initConfig(config);

  grunt.loadNpmTasks('grunt-coffeelint');
  grunt.loadNpmTasks('grunt-contrib-clean');
  grunt.loadNpmTasks('grunt-contrib-coffee');
  grunt.loadNpmTasks('grunt-contrib-jshint');
  grunt.loadNpmTasks('grunt-contrib-watch');
  grunt.loadNpmTasks('grunt-mocha-test');

  grunt.task.registerTask('build', ['clean', 'jshint', 'coffeelint', 'coffee']);
  grunt.task.registerTask('develop', ['test', 'watch']);
  grunt.task.registerTask('test', ['build', 'mochaTest']);
};
