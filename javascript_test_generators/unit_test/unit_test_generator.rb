class UnitTestGenerator < RubiGen::Base
  
  attr_reader :name, :library_name, :module_name, :test_framework
  
  def initialize(runtime_args, runtime_options = {})
    super
    usage if args.empty?
    @name = args.shift
    @library_name = args.shift || name
    @module_name = library_name.camelcase
    extract_options
  end

  def manifest
    record do |m|
      # Ensure appropriate folder(s) exists
      m.directory 'test/unit'

      if test_framework
        m.directory 'test/assets'
        m.file "test/assets/#{test_framework}.js", "test/assets/#{test_framework}.js", :collision => :skip
        m.template "test/test_#{test_framework}.html.erb",  "test/unit/#{name}_test.html"
      else
        m.template "test/test.html.erb",  "test/unit/#{name}_test.html"
      end
    end
  end

  protected
    def banner
      <<-EOS
Creates an HTML unit test file for a JavaScript library.

USAGE: #{$0} #{spec.name} name [library_name]

NOTES:
* name - creates a file test/unit/name_test.html
* library_name - is for a file src/library_name.js

EOS
    end

    def add_options!(opts)
      # opts.separator ''
      # opts.separator 'Options:'
      # For each option below, place the default
      # at the top of the file next to "default_options"
      # opts.on("-a", "--author=\"Your Name\"", String,
      #         "Some comment about this option",
      #         "Default: none") { |options[:author]| }
      # opts.on("-v", "--version", "Show the #{File.basename($0)} version number and quit.")
      opts.on("-j", "--jshoulda", "Use jshoulda test framework") { |v| options[:test_framework] = 'jshoulda'}
    end
    
    def extract_options
      # for each option, extract it into a local variable (and create an "attr_reader :author" at the top)
      # Templates can access these value via the attr_reader-generated methods, but not the
      # raw instance variable value.
      # @author = options[:author]
      @test_framework = options[:test_framework]
    end
end