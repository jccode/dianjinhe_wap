path = require 'path'

# Build configurations
module.exports = (grunt) ->
	require('load-grunt-tasks')(grunt)
	require('time-grunt')(grunt)
	pkg = require './package.json'

	grunt.initConfig
		settings:
			distDirectory: 'dist'
			srcDirectory: 'src'
			tempDirectory: '.temp'

		# Gets dependent components from bower
		# see bower.json file
		bower:
			install:
				options:
					cleanTargetDir: true
					copy: true
					layout: (type, component) ->
						path.join type
					targetDir: '.components/'
			uninstall:
				options:
					cleanBowerDir: true
					copy: false
					install: false


		# Deletes dist and .temp directories
		# The .temp directory is used during the build process
		# The dist directory contains the artifacts of the build
		# These directories should be deleted before subsequent builds
		# These directories are not committed to source control
		clean:
			working: [
				'<%= settings.tempDirectory %>'
				'<%= settings.distDirectory %>'
			]


		# Sets up a web server
		connect:
			app:
				options:
					base: '<%= settings.distDirectory %>'
					hostname: 'localhost'
					livereload: true
					middleware: (connect, options, middlewares) ->
						express = require 'express'
						# routes = require './routes'
						app = express()

						app.use express.static String(options.base)
						# routes app, options
						middlewares.unshift app
						middlewares
					open: true
					port: 3000

		# Copies directories and files from one location to another
		copy:
			app:
				files: [
					cwd: '<%= settings.srcDirectory %>'
					src: '**'
					dest: '<%= settings.tempDirectory %>'
					expand: true
				,
					cwd: '.components/'
					src: '**'
					dest: '<%= settings.tempDirectory %>'
					expand: true
				]
			dev:
				cwd: '<%= settings.tempDirectory %>'
				src: '**'
				dest: '<%= settings.distDirectory %>'
				expand: true
			prod:
				files: [
					cwd: '<%= settings.tempDirectory %>'
					src: [
						'**/*.{eot,svg,ttf,woff}'
						'**/*.{gif,jpeg,jpg,png,svg,webp}'
						'index.html'
						'scripts/ie.min.*.js'
						'scripts/scripts.min.*.js'
						'styles/styles.min.*.css'
					]
					dest: '<%= settings.distDirectory %>'
					expand: true
				]

		# Renames files based on their hashed content
		# When the files contents change, the hash value changes
		# Used as a cache buster, ensuring browsers load the correct static resources
		#
		# glyphicons-halflings.png -> glyphicons-halflings.6c8829cc6f.png
		# scripts.min.js -> scripts.min.6c355e03ee.js
		hash:
			images: '.temp/**/*.{gif,jpeg,jpg,png,svg,webp}'
			scripts:
				cwd: '.temp/scripts'
				src: [
					'ie.min.js'
					'scripts.min.js'
				]
				expand: true
			styles: '.temp/styles/styles.min.css'

		
		# Compresses png files
		imagemin:
			images:
				files: [
					cwd: '<%= settings.tempDirectory %>'
					src: '**/*.{gif,jpeg,jpg,png}'
					dest: '<%= settings.tempDirectory %>'
					expand: true
				]
				options:
					optimizationLevel: 7

		
		# Compile LESS (.less) files to CSS (.css)
		less:
			app:
				files:
					'.temp/styles/styles.css': '.temp/styles/styles.less'

		# Compile dustjs templates
		dust:
			app:
				files:
					'<%= settings.tempDirectory %>/scripts/views.js': '<%= settings.tempDirectory %>/**/*.dust'
				options:
					basePath: "<%= settings.tempDirectory %>/"
					wrapper: "amd"
					runtime: false
					wrapperOptions:
						packageName: "views"
						deps:
							dust: "dust"

		# Minifies index.html
		# Extra white space and comments will be removed
		# Content within <pre /> tags will be left unchanged
		# IE conditional comments will be left unchanged
		# Reduces file size by over 14%
		minifyHtml:
			prod:
				src: '.temp/index.html'
				ext: '.html'
				expand: true


		# RequireJS optimizer configuration for both scripts and styles
		# This configuration is only used in the 'prod' build
		# The optimizer will scan the main file, walk the dependency tree, and write the output in dependent sequence to a single file
		# Since RequireJS is not being used outside of the main file or for dependency resolution (this is handled by AngularJS), RequireJS is not needed for final output and is excluded
		# RequireJS is still used for the 'dev' build
		# The main file is used only to establish the proper loading sequence
		requirejs:
			scripts:
				options:
					baseUrl: '.temp/scripts'
					findNestedDependencies: true
					logLevel: 0
					mainConfigFile: '.temp/scripts/main.js'
					name: 'main'
					# Exclude main from the final output to avoid the dependency on RequireJS at runtime
					onBuildWrite: (moduleName, path, contents) ->
						modulesToExclude = [] # main
						shouldExcludeModule = modulesToExclude.indexOf(moduleName) >= 0

						return '' if shouldExcludeModule

						contents
					optimize: 'uglify2'
					out: '.temp/scripts/scripts.min.js'
					preserveLicenseComments: false
					skipModuleInsertion: true
					uglify:
						# Let uglifier replace variables to further reduce file size
						no_mangle: false
					useStrict: true
					wrap:
						start: '(function(){\'use strict\';'
						end: '}).call(this);'
			styles:
				options:
					baseUrl: '.temp/styles/'
					cssIn: '.temp/styles/styles.css'
					logLevel: 0
					optimizeCss: 'standard'
					out: '.temp/styles/styles.min.css'


		# Compiles underscore expressions
		#
		# The example below demonstrates the use of the environment configuration setting
		# In 'prod' build the hashed file of the concatenated and minified scripts is referened
		# In environments other than 'prod' the individual files are used and loaded with RequireJS
		#
		# <% if (config.environment === 'prod') { %>
		# 	<script src="<%= config.getHashedFile('.temp/scripts/scripts.min.js', {trim: '.temp'}) %>"></script>
		# <% } else { %>
		# 	<script data-main="/scripts/main.js" src="/scripts/libs/require.js"></script>
		# <% } %>
		template:
			indexDev:
				files:
					'.temp/index.html': '.temp/index.html'
			index:
				files: '<%= template.indexDev.files %>'
				environment: 'prod'

		# Concatenates and minifies JavaScript files
		uglify:
			scripts:
				files:
					'.temp/scripts/ie.min.js': [
						'.temp/scripts/libs/json3.js'
						'.temp/scripts/libs/html5shiv-printshiv.js'
					]

		# Run tasks when monitored files change
		watch:
			basic:
				files: [
					'src/fonts/**'
					'src/images/**'
					'src/scripts/**/*.js'
					'src/styles/**/*.css'
					'src/**/*.html'
				]
				tasks: [
					'copy:app'
					'copy:dev'
					# 'karma'
				]
				options:
					livereload: true
					nospawn: true
			less:
				files: 'src/styles/**/*.less'
				tasks: [
					'copy:app'
					'less'
					'copy:dev'
				]
				options:
					livereload: true
					nospawn: true
			dust:
				files: 'src/**/*.dust'
				tasks: [
					'copy:app'
					'dust:app'
					'copy:dev'
				]
				options:
					livereload: true
					nospawn: true
			test:
				files: 'test/**/*.*'
				tasks: [
					# 'karma'
				]
			# Used to keep the web server alive
			none:
				files: 'none'
				options:
					livereload: true

	# ensure only tasks are executed for the changed file
	# without this, the tasks for all files matching the original pattern are executed
	grunt.event.on 'watch', (action, filepath, key) ->
		file = filepath.substr(4) # trim "src/" from the beginning.  I don't like what I'm doing here, need a better way of handling paths.
		dirname = path.dirname file
		ext = path.extname file
		basename = path.basename file, ext

		grunt.config ['copy', 'app'],
			cwd: 'src/'
			src: file
			dest: '.temp/'
			expand: true

		copyDevConfig = grunt.config ['copy', 'dev']
		copyDevConfig.src = file

		if key is 'less'
			copyDevConfig.src = [
				path.join(dirname, "#{basename}.{less,css}")
				path.join(dirname, 'styles.css')
			]
		if key is 'dust'
			copyDevConfig.src = [
				path.join(dirname, "#{basename}.dust")
				"scripts/views.js"
			]

		grunt.config ['copy', 'dev'], copyDevConfig

	# Compiles the app with non-optimized build settings
	# Places the build artifacts in the dist directory
	# Enter the following command at the command line to execute this build task:
	# grunt build
	grunt.registerTask 'build', [
		'clean:working'
		'bower:install'
		'copy:app'
		'dust:app'
		'less'
		'template:indexDev'
		'copy:dev'
	]

	# Compiles the app with non-optimized build settings
	# Places the build artifacts in the dist directory
	# Opens the app in the default browser
	# Watches for file changes, and compiles and reloads the web browser upon change
	# Enter the following command at the command line to execute this build task:
	# grunt or grunt default
	grunt.registerTask 'default', [
		'build'
		'connect'
		'watch'
	]

	# Identical to the default build task
	# Compiles the app with non-optimized build settings
	# Places the build artifacts in the dist directory
	# Opens the app in the default browser
	# Watches for file changes, and compiles and reloads the web browser upon change
	# Enter the following command at the command line to execute this build task:
	# grunt dev
	grunt.registerTask 'dev', [
		'default'
	]

	# Compiles the app with optimized build settings
	# Places the build artifacts in the dist directory
	# Enter the following command at the command line to execute this build task:
	# grunt prod
	grunt.registerTask 'prod', [
		'clean:working'
		'bower:install'
		'copy:app'
		'imagemin'
		'hash:images'
		'less'
		'requirejs'
		'uglify'
		'hash:scripts'
		'hash:styles'
		'template:index'
		'minifyHtml'
		'copy:prod'
	]

	# Opens the app in the default browser
	# Build artifacts must be in the dist directory via a prior grunt build, grunt, grunt dev, or grunt prod
	# Enter the following command at the command line to execute this build task:
	# grunt server
	grunt.registerTask 'server', [
		'connect'
		'watch:none'
	]

	# Looks like the prevailing winds are pointing to use 'serve' instead of 'server'
	# Why not both?  :)
	# grunt serve
	grunt.registerTask 'serve', [
		'server'
	]

	# Compiles the app with non-optimized build settings
	# Places the build artifacts in the dist directory
	# Runs unit tests via karma
	# Enter the following command at the command line to execute this build task:
	# grunt test
	# 
	# grunt.registerTask 'test', [
	# 	'build'
	# 	'karma'
	# ]

