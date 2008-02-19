class JavaScriptTest::Browser
  def initialize(path)
    @path = path
  end
end

if JavaScriptTest::Browser.new('').macos?
  class JavaScriptTest::SafariBrowser
    def setup; end # no need to create new Browser, as open command automates this
    def visit(file)
      @path ||= 'Safari.app'
      `open #{file} -a #{@path} -g`
    end
    def setup; end # no need to destroy Browser
  end
end