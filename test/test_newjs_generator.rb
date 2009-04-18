require File.join(File.dirname(__FILE__), "test_generator_helper.rb")

class TestNewjsGenerator < Test::Unit::TestCase
  include RubiGen::GeneratorTestHelper

  def setup
    bare_setup
  end

  def teardown
    bare_teardown
  end

  # Some generator-related assertions:
  #   assert_generated_file(name, &block) # block passed the file contents
  #   assert_directory_exists(name)
  #   assert_generated_class(name, &block)
  #   assert_generated_module(name, &block)
  #   assert_generated_test_for(name, &block)
  # The assert_generated_(class|module|test_for) &block is passed the body of the class/module within the file
  #   assert_has_method(body, *methods) # check that the body has a list of methods (methods with parentheses not supported yet)
  #
  # Other helper methods are:
  #   app_root_files - put this in teardown to show files generated by the test method (e.g. p app_root_files)
  #   bare_setup - place this in setup method to create the APP_ROOT folder for each test
  #   bare_teardown - place this in teardown method to destroy the TMP_ROOT or APP_ROOT folder after each test

  def test_generator_without_options
    run_generator('newjs', [APP_ROOT], sources)
    assert_directory_exists "lib"
    assert_directory_exists "config"
    assert_directory_exists "src"
    assert_directory_exists "script"
    assert_directory_exists "tasks"
    assert_directory_exists "test/assets"
    assert_generated_file   "test/assets/unittest.css"
    assert_generated_file   "test/assets/jsunittest.js"
    assert_generated_file   "Rakefile"
    assert_generated_file   "README.txt"
    assert_generated_file   "License.txt"
    assert_generated_file   "History.txt"
    assert_generated_file   "script/rstakeout"
    assert_generated_file   "script/js_autotest"
    assert_generated_file   "tasks/javascript_test_autotest_tasks.rake"
    assert_generated_file   "tasks/environment.rake"
    assert_generated_file   "tasks/deploy.rake"
    assert_generated_file   "config/javascript_test_autotest.yml.sample"
    assert_generated_file   "src/myproject.js.erb"
    assert_generated_file   "src/HEADER"
    assert_generated_file   "lib/protodoc.rb"
    assert_generated_file   "lib/jstest.rb"
  end

  def test_generator_for_jshoulda_and_jquery
    run_generator('newjs', [APP_ROOT], sources, {:test_framework => 'jshoulda', :framework => 'jquery'})
    assert_directory_exists "lib"
    assert_directory_exists "config"
    assert_directory_exists "src"
    assert_directory_exists "script"
    assert_directory_exists "tasks"
    assert_directory_exists "test/assets"
    assert_generated_file   "test/assets/unittest.css"
    assert_generated_file   "test/assets/jsunittest.js"
    assert_generated_file   "test/assets/jshoulda.js"
    assert_generated_file   "lib/ext/jquery.js"
    assert_generated_file   "Rakefile"
    assert_generated_file   "README.txt"
    assert_generated_file   "License.txt"
    assert_generated_file   "History.txt"
    assert_generated_file   "script/rstakeout"
    assert_generated_file   "script/js_autotest"
    assert_generated_file   "tasks/javascript_test_autotest_tasks.rake"
    assert_generated_file   "tasks/environment.rake"
    assert_generated_file   "tasks/deploy.rake"
    assert_generated_file   "config/javascript_test_autotest.yml.sample"
    assert_generated_file   "src/myproject.js.erb"
    assert_generated_file   "src/HEADER"
    assert_generated_file   "lib/protodoc.rb"
    assert_generated_file   "lib/jstest.rb"
  end

  private
  def sources
    [RubiGen::PathSource.new(:test, File.join(File.dirname(__FILE__),"..", generator_path))
    ]
  end

  def generator_path
    "app_generators"
  end
end
