Feature: Apply the latest distribution files from vendored projects into generators
  In order to cheaply include latest JS libraries into the generators
  As a newjs developer/deployer
  I want to copy into newjs generators the JavaScript files from vendored projects

  Scenario: Copy across jsunittest into generators
    Given this project is active project folder
    When I invoke task "rake vendor:update:jsunittest"
    Then file 'app_generators/newjs/templates/test/assets/jsunittest.js' is same as file 'vendor/jsunittest/dist/jsunittest.js'  
    Then file 'app_generators/newjs/templates/test/assets/unittest.css' is same as file 'vendor/jsunittest/dist/unittest.css'  
    Then file 'app_generators/newjs_iphone/templates/Html/test/assets/jsunittest.js' is same as file 'vendor/jsunittest/dist/jsunittest.js'  
    Then file 'app_generators/newjs_iphone/templates/Html/test/assets/unittest.css' is same as file 'vendor/jsunittest/dist/unittest.css'  
    Then file 'rails_generators/javascript_test/templates/assets/jsunittest.js' is same as file 'vendor/jsunittest/dist/jsunittest.js'  
    Then file 'rails_generators/javascript_test/templates/assets/unittest.css' is same as file 'vendor/jsunittest/dist/unittest.css'  

  Scenario: Copy across jshoulda into generators
    Given this project is active project folder
    When I invoke task "rake vendor:update:jshoulda"
    Then file 'rails_generators/javascript_test/templates/assets/jshoulda.js' is same as file 'vendor/jshoulda/dist/jshoulda.js'  

