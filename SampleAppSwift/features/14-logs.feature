Feature: Logs view
This text checks that
Logs are posted after an
auth request is handled

Scenario: Logs Check
Then I wait to see "Security"
Then I scroll down 
Then I scroll down
Then I wait to see "List of Logs (Default UI)"
Then I press "Logs (Default UI)"
Then I wait to see " List of Logs (Default UI)"
Then I press "CLEARED"
Then I wait to see "OK"
Then I press "OK"
Then I wait to see "List of Logs (Default UI)"
Then I press "NavBack"
Then I wait to see "OTP"

Scenario: Logs custom UI
Then I wait to see "Security"
Then I scroll down
Then I scroll down
Then I wait to see "List of Logs (Custom UI)"
Then I press "List of Logs (Custom UI)"
Then I wait to see "List of Logs (Custom UI)"
Then I scroll down
Then I scroll up
Then I press "NavBack"
Then I wait to see "OTP"

Scenario: Logs custom UI
Then I wait to see "Security"
Then I scroll down
Then I scroll down
Then I wait to see "List of Logs 2 (Custom UI)"
Then I press "List of Logs 2 (Custom UI)"
Then I wait to see "List of Logs 2 (Custom UI)"
Then I scroll down
Then I scroll up
Then I press "NavBack"
Then I wait to see "OTP"

