Feature: Linking device for the first time

  Scenario: As an implementer, I want to allow
  users to link their devices when they have a
  valid linking code.
  
Then I wait to see "Linking (Default Manual)"
Then I press "Linking (Custom Manual)"
Then I wait to see "LINK"
Then I press "toggle_button"
Then I enter a valid linking code into field with id "link_text_field"
Then I press "link" 
Then I wait to see "Linking (Default Manual)"