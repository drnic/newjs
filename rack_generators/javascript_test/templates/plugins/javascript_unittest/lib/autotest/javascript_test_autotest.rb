module JavascriptTestAutotest
  class Browser
    class << self
      def browser(browser, path)
        case(browser.to_sym)
          when :firefox
            JavaScriptTest::FirefoxBrowser.new(path)
          when :safari
            JavaScriptTest::SafariBrowser.new(path)
          when :ie
            JavaScriptTest::IEBrowser.new(path)
          when :konqueror
            JavaScriptTest::KonquerorBrowser.new(path)
          else
            browser
        end
      end
    end
  end
end

require "javascript_test_autotest/config"
