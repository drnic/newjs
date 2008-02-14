module JavascriptTestAutotest
  class Browser
    class << self
      def browser(browser, path)
        case(browser.to_sym)
          when :firefox
            FirefoxBrowser.new(path)
          when :safari
            SafariBrowser.new(path)
          when :ie
            IEBrowser.new(path)
          when :konqueror
            KonquerorBrowser.new(path)
          else
            browser
        end
      end
    end
  end
end

require File.dirname(__FILE__) + "/javascript_test_autotest/config"
