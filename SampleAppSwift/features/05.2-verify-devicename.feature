Feature: Linking device for the first time

  Scenario: As an implementer, I want to allow
  users to link their devices when they have a
  valid linking code.
  
Then I wait to see "Linking (Default Manual)"
Then I scroll down
Then I press "Devices (Default UI)"
Then I should see device name
