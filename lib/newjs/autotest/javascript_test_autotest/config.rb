require 'yaml'

class JavascriptTestAutotest::Config
  def self.get var, default = nil
    value = configs[var.to_s]
    value ||= default
    value ||= yield if block_given?
    value
  end

  private
    def self.configs
      unless defined? @@configs
        file = File.expand_path("#{APP_ROOT}/config/javascript_test_autotest.yml")
        @@configs = File.exist?(file) ? YAML.load_file(file) : {}
      end
      @@configs
    end

end
