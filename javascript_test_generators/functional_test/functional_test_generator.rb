class FunctionalTestGenerator < RubiGen::Base
  
  attr_reader :name, :dist_name, :test_framework
  
  def initialize(runtime_args, runtime_options = {})
    super
    usage if args.empty?
    @name = args.shift
    @dist_name = args.shift || base_name
    extract_options
  end

  def manifest
    record do |m|
      # Ensure appropriate folder(s) exists
      m.directory 'test/functional'

      if test_framework == 'jshoulda'
        # Ensure jshoulda exists. TODO Should be moved to the newjs generator?
        m.directory 'test/assets'
        m.file 'test/assets/jshoulda.js', 'test/assets/jshoulda.js', :collision => :skip
      end

      # Create stubs
      m.template "test/test.html.erb",  "test/functional/#{name}_test.html"
    end
  end

  protected
    def banner
      <<-EOS
Creates a functional test file for the final distribution JavaScript file(s).

USAGE: #{$0} #{spec.name} name [dist_name]

NOTES:
* name - creates a file test/functional/name_test.html
* dist_name - is for a file dist/base_name.js or dist/dist_name.js

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
      opts.on("--jshoulda", "Use jShoulda to write the test") { |v| options[:test_framework] = 'jshoulda'}
    end
    
    def extract_options
      # for each option, extract it into a local variable (and create an "attr_reader :author" at the top)
      # Templates can access these value via the attr_reader-generated methods, but not the
      # raw instance variable value.
      # @author = options[:author]
      @test_framework = options[:test_framework]
      @test_framework ||= 'jshoulda' if File.exists?('test/assets/jshoulda.js')
    end
end