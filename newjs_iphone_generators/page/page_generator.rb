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
      m.directory 'src'
      m.directory 'test/unit'
      m.directory 'test/fixtures'

      ["src/name.css.erb", "src/name.html.erb", "src/name.js.erb",
        "test/unit/name_test.html.erb", "test/fixtures/name.js.erb"].each do |file|
        target_name = file.gsub(/name/, name).gsub(/.erb/,'')
        m.template file, target_name
      end
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
