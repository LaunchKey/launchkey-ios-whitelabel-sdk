Feature: Attempting to link with an invalid linking code

  Scenario: As an implementer, I want to let
  users know they have attempted to link their 
  devices using an invalid linking code.
  
Then I wait to see "Linking (Default Manual)"
Then I press "Linking (Custom Manual)"
Then I wait to see "LINK"
Then I enter "badCode" into the "link_text_field" text field
Then I press "link"
Then I wait to see "OK"
Then I press "OK"
Then I wait to see "LINK"
Then I press "NavBack"
Then I wait to see "Linking (Default Manual)"
