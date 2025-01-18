Feature: Reset Account Password

  As a user I want to be able to change/recover my password to be able to maintain access to my account

  # Login Page

  Scenario: User requests password reset
    Given the user has opened the app
    And the user has forgotten his password
    And the user is on the Login Page
    When the user enters his email on the email field
    And the user clicks on the 'Forgot Password?' text
    Then the user should view a dialog indicating that a password reset email has been sent to the user's provided email
    And the user should receive a password reset email

  Scenario: User clicks on password reset text without providing an email
    Given the user has opened the app
    And the user has forgotten his password
    And the user is on the Login Page
    When the user clicks on the 'Forgot Password?' text
    And the user had not provided an email
    Then the user should view a dialog indicating that the email field is required

  Scenario: User clicks on password reset text providing an invalid email
    Given the user has opened the app
    And the user has forgotten his password
    And the user is on the Login Page
    When the user clicks on the 'Forgot Password?' text
    And the user provided an invalid email
    Then the user should view a dialog indicating that the email provided is invalid

  # Edit Profile Page

  Scenario: User clicks on the "Change Password" text
    Given the user has authenticated into the app
    And the user wants to change his password
    And the user navigated to the Edit Profile Page
    When the user clicks on the 'Change Password' text
    Then the user should view a dialog asking for the user's confirmation to change his password

  Scenario: User confirms password change
    Given the user has authenticated into the app
    And the user wants to change his password
    And the user navigated to the Edit Profile Page
    And the user clicked on the 'Change Password' text
    And the user clicked on the 'Confirm' button, indicating that he wants to change his password
    Then the user should view a dialog indicating that the an email has been sent to the user's inbox with a link to change his password
    And the user should receive an email with a link to change his password

  Scenario: User refuses password change
    Given the user has authenticated into the app
    And the user navigated to the Edit Profile Page
    And the user clicked on the 'Change Password' text
    And the user clicked on the 'Cancel' button, indicating that he does not want to change his password
    Then the user should see the confirmation dialog disappear
    And the user should not receive an email with a link to change his password
    And the user should remain on the Edit Profile Page
