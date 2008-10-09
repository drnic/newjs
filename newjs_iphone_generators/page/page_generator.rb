class PageGenerator < RubiGen::Base

  attr_reader :name, :module_name

  def initialize(runtime_args, runtime_options = {})
    super
    usage if args.empty?
    @name        = args.shift
    @module_name = @name.camelcase
  end

  def manifest
    record do |m|
      # Ensure appropriate folder(s) exists
      m.directory 'src'
      m.directory 'test'

      # Create stubs
      ["src/name.css.erb", "src/name.html.erb", "src/name.js.erb",
        "test/test_name.html.erb"].each do |file|
        target_name = file.gsub(/name/, name).gsub(/.erb/,'')
        m.template file, target_name
      end
      # m.template "template.rb",  "some_file_after_erb.rb"
      # m.template_copy_each , "src"
      # m.file     "file",         "some_file_copied"
      # m.file_copy_each ["path/to/file", "path/to/file2"]
    end
  end

  protected
    def banner
      <<-EOS
Creates a page with a loadData() JavaScript method
to load data from Objective-C. This page would be
used in a WebKit view to show some static data.

USAGE: #{$0} #{spec.name} name
EOS
    end
end
