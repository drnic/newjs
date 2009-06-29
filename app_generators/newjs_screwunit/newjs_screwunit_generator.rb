class NewjsScrewunitGenerator < RubiGen::Base

  DEFAULT_SHEBANG = File.join(Config::CONFIG['bindir'],
                              Config::CONFIG['ruby_install_name'])

  default_options :src_folder => 'src'

  attr_reader :name
  attr_reader :src_folder
  attr_reader :greasemonkey

  def initialize(runtime_args, runtime_options = {})
    super
    usage if args.empty?
    @destination_root = File.expand_path(args.shift)
    @name = base_name
    extract_options
  end

  def manifest
    record do |m|
      m.directory '.'
      m.directory src_folder
      m.directory 'spec/fixtures'
      m.directory 'vendor/plugins'

      # Create stubs
      m.template "Rakefile.erb",  "Rakefile"
      # m.template_copy_each %w[Rakefile]
      # m.file     "file",         "some_file_copied"
      # m.file_copy_each ["path/to/file", "path/to/file2"]

      m.dependency "install_rubigen_scripts", [destination_root, 'newjs_screwunit'],
        :shebang => options[:shebang], :collision => :force
    end
  end

  protected
    def banner
      <<-EOS
Creates a ...

USAGE: #{spec.name} name
EOS
    end

    def add_options!(opts)
      opts.separator ''
      opts.separator 'Options:'
      # For each option below, place the default
      # at the top of the file next to "default_options"
      opts.on("--src=folder", String,
              "Folder for development of JavaScript source files",
              "Default: src") { |o| options[:src_folder] = o }
      opts.on("-v", "--version", "Show the #{File.basename($0)} version number and quit.")
    end

    def extract_options
      @src_folder = options[:src_folder]
    end
end