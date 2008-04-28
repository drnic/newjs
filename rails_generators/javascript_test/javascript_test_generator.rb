class JavascriptTestGenerator < Rails::Generator::Base
  DEFAULT_SHEBANG = File.join(Config::CONFIG['bindir'],
                              Config::CONFIG['ruby_install_name'])

  default_options :framework => nil

  attr_reader :path, :name, :library_name
  attr_reader :nested_folder, :reverse_nested_folder
  attr_reader :framework

  def initialize(runtime_args, runtime_options = {})
    super
    usage if args.empty?
    @path = args.shift
    name_parts = path.split('/')
    @name = name_parts.pop
    @nested_folder = name_parts.first # could be nil if not nested
    @reverse_nested_folder = (@nested_folder || "").split('/').map { |folder| "../" }.join
    @library_name = args.shift || name
    extract_options
  end

  def manifest
    script_options = { :chmod => 0755, :shebang => options[:shebang] == DEFAULT_SHEBANG ? nil : options[:shebang] }
    windows        = (RUBY_PLATFORM =~ /dos|win32|cygwin/i) || (RUBY_PLATFORM =~ /(:?mswin|mingw)/)

    record do |m|
      # Ensure appropriate folder(s) exists
      m.directory 'config'
      m.directory 'script'
      m.directory 'test/javascript/assets'
      m.directory 'vendor/plugins/javascript_unittest/lib'
      m.directory 'vendor/plugins/javascript_unittest/tasks'
      m.directory "test/javascript/#{nested_folder}" if nested_folder
      m.directory "public/javascripts/ext" if framework

      # Create stubs
      m.file     "assets/jsunittest.js", "test/javascript/assets/jsunittest.js"
      m.file     "assets/unittest.css",  "test/javascript/assets/unittest.css"
      m.file     "ext/#{framework}.js", "public/javascripts/ext/#{framework}.js" if framework

      m.file     "config/javascript_test_autotest.yml.sample",
                  "config/javascript_test_autotest.yml.sample"

      m.file     "plugins/javascript_unittest/lib/jstest.rb",
                  "vendor/plugins/javascript_unittest/lib/jstest.rb"
      m.file     "plugins/javascript_unittest/tasks/runner.rake",
                  "vendor/plugins/javascript_unittest/tasks/runner.rake"
      m.file     "plugins/javascript_unittest/tasks/autotest.rake",
                  "vendor/plugins/javascript_unittest/tasks/autotest.rake"
      m.file     "plugins/javascript_unittest/README",
                  "vendor/plugins/javascript_unittest/README"
      m.template "test.html.erb",  "test/javascript/#{path}_test.html"

      %w[rstakeout js_autotest].each do |file|
        m.template "script/#{file}",        "script/#{file}", script_options
        m.template "script/win_script.cmd", "script/#{file}.cmd",
          :assigns => { :filename => file } if windows
      end
    end
  end

  protected
    def banner
      <<-EOS
Creates an HTML unit test file for a JavaScript library.

USAGE: #{$0} #{spec.name} name [library_name]

NOTES:
* name - creates a file test/javascript/name_test.html; can have subfolders: models/name
* library_name - is for a file public/javascripts/library_name.js
EOS
    end

    def add_options!(opts)
      opts.separator ''
      opts.separator 'Options:'
      opts.on("-F", "--framework=FRAMEWORK", String,
              "Include jquery or prototypejs libraries",
              "Options: jquery, prototype",
              "Default: none") { |x| options[:framework] = x }
    end

    def extract_options
      @framework = options[:framework]
    end
end