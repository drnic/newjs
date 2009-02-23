Feature: Apply the latest distribution files from vendored projects into generators
  In order to cheaply include latest JS libraries into the generators
  As a newjs developer/deployer
  I want to copy into newjs generators the JavaScript files from vendored projects

  Scenario: Copy across jsunittest into generators
    Given this project is active project folder
    When task 'rake vendor:update:jsunittest' is invoked
    Then file 'app_generators/newjs/templates/test/assets/jsunittest.js' is same as file 'vendor/jsunittest/dist/jsunittest.js'  
    Then file 'app_generators/newjs/templates/test/assets/unittest.css' is same as file 'vendor/jsunittest/dist/unittest.css'  
    Then file 'app_generators/newjs_iphone/templates/Html/test/assets/jsunittest.js' is same as file 'vendor/jsunittest/dist/jsunittest.js'  
    Then file 'app_generators/newjs_iphone/templates/Html/test/assets/unittest.css' is same as file 'vendor/jsunittest/dist/unittest.css'  
    Then file 'rails_generators/javascript_test/templates/assets/jsunittest.js' is same as file 'vendor/jsunittest/dist/jsunittest.js'  
    Then file 'rails_generators/javascript_test/templates/assets/unittest.css' is same as file 'vendor/jsunittest/dist/unittest.css'  
