Feature: Verifying "Unlinked" state of the device

  Scenario: As an implementer, I want to make
  sure users do not try to do things only 
  available when the device has been
  linked.
  
Then I wait to see "Linking (Default Manual)"
Then I press "Check For Requests"
Then I wait to see "OK"
Then I press "OK"

