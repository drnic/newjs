class NewjsGenerator < RubiGen::Base
  DEFAULT_SHEBANG = File.join(Config::CONFIG['bindir'],
                              Config::CONFIG['ruby_install_name'])
  
  default_options :shebang => DEFAULT_SHEBANG,
                  :author => nil,
                  :email       => nil,
                  :version     => '0.0.1'
  
  
  attr_reader :name, :module_name
  attr_reader :version, :version_str, :author, :email
  
  
  def initialize(runtime_args, runtime_options = {})
    super
    usage if args.empty?
    @destination_root = File.expand_path(args.shift)
    @name = base_name
    @module_name = name.camelize
    extract_options
  end

  def manifest
    script_options     = { :chmod => 0755, :shebang => options[:shebang] == DEFAULT_SHEBANG ? nil : options[:shebang] }
    windows            = (RUBY_PLATFORM =~ /dos|win32|cygwin/i) || (RUBY_PLATFORM =~ /(:?mswin|mingw)/)
    
    record do |m|
      # Ensure appropriate folder(s) exists
      m.directory ''
      BASEDIRS.each { |path| m.directory path }

      # Create stubs
      # m.template "template.rb",  "some_file_after_erb.rb"
      # m.file     "file",         "some_file_copied"
      m.file_copy_each %w[unittest.css unittest.js prototype.js], "test/assets"
      m.file_copy_each %w[javascript_test_autotest_tasks.rake], "tasks"
      m.file_copy_each %w[javascript_test_autotest.yml.sample], "config"
      m.file_copy_each %w[protodoc.rb], "lib"
      m.file_copy_each %w[README.txt]
      m.template_copy_each %w[Rakefile History.txt License.txt]
      m.template_copy_each %w[HEADER.erb], "src"
      m.template "src/library.js.erb", "src/#{name}.js"
      
      %w[rstakeout js_autotest].each do |file|
        m.template "script/#{file}",        "script/#{file}", script_options
        m.template "script/win_script.cmd", "script/#{file}.cmd", 
          :assigns => { :filename => file } if windows
      end
      
      m.dependency "install_rubigen_scripts", [destination_root, 'javascript', 'newjs'], 
        :shebang => options[:shebang], :collision => :force
    end
  end

  protected
    def banner
      <<-EOS
Creates a JavaScript project.

USAGE: #{spec.name} name"
EOS
    end

    def add_options!(opts)
      opts.separator ''
      opts.separator 'Options:'
      # For each option below, place the default
      # at the top of the file next to "default_options"
      opts.on("-a", "--author=\"Your Name\"", String,
              "Default: none") { |x| options[:author] = x }
      opts.on("-e", "--email=\"your@email.com\"", String,
              "Your email to be inserted into generated files.",
              "Default: ~/.rubyforge/user-config.yml[email]") { |x| options[:email] = x }
      opts.on("-v", "--version", "Show the #{File.basename($0)} version number and quit.")
      opts.on("-V", "--set-version=X.Y.Z", String,
              "Initial version of the project you are creating.",
              "Default: 0.0.1") { |x| options[:version] = x }
    end
    
    def extract_options
      @version           = options[:version].to_s.split(/\./)
      @version_str       = @version.join('.')
      @author            = options[:author]
      @email             = options[:email]
      unless @author && @email
        require 'newgem/rubyforge'
        rubyforge_config = Newgem::Rubyforge.new
        @author ||= rubyforge_config.full_name
        @email  ||= rubyforge_config.email
      end
    end

    # Installation skeleton.  Intermediate directories are automatically
    # created so don't sweat their absence here.
    BASEDIRS = %w(
      config
      lib
      src
      script
      tasks
      test/assets
    )
end