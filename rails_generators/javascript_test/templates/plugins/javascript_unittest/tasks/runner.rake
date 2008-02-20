require File.dirname(__FILE__) + '/../lib/jstest'

namespace :test do
  desc "Runs all the JavaScript unit tests and collects the results"
  JavaScriptTestTask.new(:javascripts, 4711) do |t|
    testcases        = ENV['TESTCASES']
    tests_to_run     = ENV['TESTS']    && ENV['TESTS'].split(',')
    browsers_to_test = ENV['BROWSERS'] && ENV['BROWSERS'].split(',')

    t.mount("/dist")
    t.mount("/public/javascripts")
    t.mount("/test")

    Dir["test/javascript/*_test.html"].sort.each do |test_file|
      tests = testcases ? { :url => "/#{test_file}", :testcases => testcases } : "/#{test_file}"
      test_filename = test_file[/.*\/(.+?)\.html/, 1]
      t.run(tests) unless tests_to_run && !tests_to_run.include?(test_filename)
    end

    %w( safari firefox ie konqueror opera ).each do |browser|
      t.browser(browser.to_sym) unless browsers_to_test && !browsers_to_test.include?(browser)
    end
  end
end
