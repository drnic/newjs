Feature: Newjs encapsulating screwunit and blue-ridge
  In order to reduce the cost of starting a new JS project using Screw.Unit and blue-ridge
  As a JavaScript developer
  I want a generator

  Scenario: Generate a new JavaScript project using Screw.Unit/Blue-ridge for testing
    When I run newjs_screwunit for project "my_project" with options ""
    Then folder "src" is created
    And folder "spec" is created
    And folder "vendor/plugin/blue-ridge" is created
    And Rakefile can display tasks successfully
  
  Scenario: Generate a new JavaScript project with source code in public folder
    When I run newjs_screwunit for project "my_project" with options "--src=public"
    Then folder "public" is created
    Then folder "src" is not created
    Then folder "spec" is created
    And Rakefile can display tasks successfully
