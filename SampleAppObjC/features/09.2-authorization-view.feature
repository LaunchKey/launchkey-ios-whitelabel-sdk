Feature: Authorizations View
This test checks if
accepted auths are
logged properly for users to see

Scenario: Check zero factor application
Then I wait to see "Security"
Then I scroll down
Then I press "Authorizations (Default UI)"
Then I wait to see "Authorizations (Default UI)"
Then I drag "image_label" to "time_label"
Then I wait to see "Authorizations (Default UI)"
Then I press "delete"
Then I wait for 8 seconds