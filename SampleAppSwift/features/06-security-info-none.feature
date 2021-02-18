Feature: Default security information

  Scenario: As an implementer, I want 
  to make sure the Security Service 
  returns no information on factors 
  since none are set.
  
Then I wait to see "Linking (Default Manual)"
Then I press "Security Information"
Then I wait to see "OK"
Then I press "OK"
    
