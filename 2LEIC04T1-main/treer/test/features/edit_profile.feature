Feature: Edit Profile Information

  As a user I want to be able to edit my profile information so that I can keep my profile up to date.

  Background:
    Given I am logged in as a user
    And I am on the Edit Profile page

  Scenario: User can change their profile picture
    Given I want to change my profile picture
    When I click on the "Upload Image" button
    And I select a new image from my device
    Then I should see the new image as my profile picture

  Scenario: User can change their name
    Given I want to change my account name
    When I change the "Name" field to "John Doe"
    And I click on the "Save" button
    Then I should see my name updated to "John Doe"

  Scenario: User leaves the name field empty
    Given I want to change my account name
    When I leave the "Name" field empty
    And I click on the "Save" button
    Then I should see a pop-up with an error message saying "Name cannot be empty".

  # Invalid name can be defined as a name that contains special characters or numbers.
  Scenario: User enters a invalid name
    Given I want to change my account name
    When I change the "Name" field to an invalid name
    And I click on the "Save" button
    Then I should see a pop-up with an error message saying "Invalid Name".

  Scenario: User can change their username
    Given I want to change my account username
    When I change the "Username" field to "johndoe01"
    And I click on the "Save" button
    Then I should see my username updated to "johndoe01"

  Scenario: User leaves the username field empty
    Given I want to change my account username
    When I leave the "Username" field empty
    And I click on the "Save" button
    Then I should see a pop-up with an error message saying "Username cannot be empty".

  # Invalid username can be defined as a username that contains special characters, spaces or symbols.
  Scenario: User enters an invalid username
    Given I want to change my account username
    When I change the "Username" field to an invalid username
    And I click on the "Save" button
    Then I should see a pop-up with an error message saying "Invalid Username".

  Scenario: User enters a username that is already in use
    Given I want to change my account username
    And another user with the username "taken_username" exists
    When I change the "Username" field to "taken_username"
    And I click on the "Save" button
    Then I should see a pop-up with an error message saying "Username Already Exists".
