module.exports = function(grunt) {

    require('time-grunt')(grunt);

    grunt.initConfig({
        pkg: grunt.file.readJSON('package.json'),

        watch: {
            options: {livereload: true},
            scripts: {
                files: ['vendor/**/(dist|js)/*.js','js/*.js'],
                tasks: ['concat:javascript', 'uglify'],
                options: {spawn: false}
            },
            css: {
                files: ['scss/**/*.{scss,sass}'],
                tasks: ['sass', 'concat:css', 'cssmin'],
                options: {spawn: false}
            },
            images: {
                files: ['articles/images/*.{png,jpg,gif}', 'images/*.{png,jpg,gif}'],
                tasks: ['newer:imagemin'],
                options: {spawn: false}
            },
            ruby: {
                files: ['lib/**/*.rb', '*.rb', 'spec/**/*_spec.rb', 'spec/spec_helper.rb'],
                tasks: ['rspec'],
                options: {spawn: false}
            }
        },
        sass: {
            dist: {
                options: {style: 'compact'},
                files: {'public/main.css': 'scss/main.scss'}
            }
        },
        concat: {
            javascript: {
                src: [
                    'vendor/pushy/js/pushy.js',
                    'js/*.js'
                    ],
                dest: 'public/production.js'
            },
            jquery: {
                src: ['vendor/jquery/dist/jquery.min.js'],
                dest: 'public/jquery.min.js'
            },
            css: {
                src: ['public/main.css'],
                dest: 'public/all.css'
            }
        },
        uglify: {
            javascript: {
                src: 'public/production.js',
                dest: 'public/production.min.js'
            }
        },
        cssmin: {
          options: {
            shorthandCompacting: false,
            roundingPrecision: -1
          },
          target: {
            files: { 'public/all.min.css': 'public/all.css'}
          }
        },
        imagemin: {
            dynamic: {
                files: [{
                    expand: true,
                    src: ['articles/images/*.{png,jpg,gif}'],
                    dest: 'public/article-images',
                    flatten: true
                },{
                    expand: true,
                    src: ['images/*.{png,jpg,gif}'],
                    dest: 'public/images',
                    flatten: true
                }]
            }
        },
        'check-gems': {
            test: {
              files: [{src: ['./']}]
            }
        },
        exec: {
            rspec_fast: 'rspec -t ~@integration_test',
            rspec_all: 'rspec'
        },
        foreman: {
            dev: {
                env: [ ".env" ],
                procfile: "Procfile",
                port: 3001
            }
        }
    });

    // 3. Where we tell Grunt we plan to use this plug-in.
    grunt.loadNpmTasks('grunt-contrib-concat');
    grunt.loadNpmTasks('grunt-contrib-uglify');
    grunt.loadNpmTasks('grunt-contrib-imagemin');
    grunt.loadNpmTasks('grunt-contrib-watch');
    grunt.loadNpmTasks('grunt-contrib-sass');
    grunt.loadNpmTasks('grunt-contrib-cssmin');
    grunt.loadNpmTasks('grunt-newer');
    grunt.loadNpmTasks('grunt-check-gems');
    grunt.loadNpmTasks('grunt-exec');
    grunt.loadNpmTasks("grunt-foreman");

    // 4. Where we tell Grunt what to do when we type "grunt" into the terminal.
    grunt.registerTask('build', ['check-gems', 'rspec', 'sass', 'concat', 'uglify', 'cssmin', 'imagemin']);
    grunt.registerTask('default', ['sass', 'concat', 'uglify', 'cssmin', 'newer:imagemin']);
    grunt.registerTask('rspec', 'exec:rspec_fast');
    grunt.registerTask('rspec:all', 'exec:rspec_all');
    grunt.registerTask('serve', ['default', 'foreman:dev']);
};
