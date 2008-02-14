class Browser
  def initialize(path)
    unless path == :ignore
      @path = path
      puts "WARNING: #{self} does not exist at #{@path}" unless File.exists?(@path)
    end
  end
end

if Browser.new(:ignore).macos?
  class SafariBrowser
    def setup; end # no need to create new Browser, as open command automates this
    def visit(file)
      @path ||= 'Safari.app'
      `open #{file} -a #{@path} -g`
    end
    def teardown; end # no need to destroy Browser
  end

  class FirefoxBrowser
    def setup; end # no need to create new Browser, as open command automates this
    def visit(file)
      @path ||= 'Safari.app'
      puts "open #{file} -a #{@path} -g"
      `open #{file} -a #{@path} -g`
    end
    def teardown; end # no need to destroy Browser
  end
end