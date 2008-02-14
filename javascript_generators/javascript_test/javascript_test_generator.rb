class JavascriptTestGenerator < RubiGen::Base
  
  attr_reader :name, :library_name
  
  def initialize(runtime_args, runtime_options = {})
    super
    usage if args.empty?
    @name = args.shift
    @library_name = args.shift || name
    extract_options
  end

  def manifest
    record do |m|
      # Ensure appropriate folder(s) exists
      m.directory 'test'

      # Create stubs
      m.template "test/test.html.erb",  "test/#{name}_test.html"
    end
  end

  protected
    def banner
      <<-EOS
Creates an HTML test file for a JavaScript library.

USAGE: #{$0} #{spec.name} name [library_name]"

NOTES:
* name - creates a file test/name_test.html
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
    end
    
    def extract_options
      # for each option, extract it into a local variable (and create an "attr_reader :author" at the top)
      # Templates can access these value via the attr_reader-generated methods, but not the
      # raw instance variable value.
      # @author = options[:author]
    end
end