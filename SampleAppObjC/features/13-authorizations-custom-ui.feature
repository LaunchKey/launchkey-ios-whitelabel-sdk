Feature: Authorizations (Custom UI)
This test checks to see 
if the custom view shows
active auth sessions

Scenario: Authorizations (Custom UI)
Then I wait to see "Security"
Then I request an auth request
Then I press "Check For Requests"
Then I wait to see "Request"
Then I drag "auth_switch" to "login_title"
Then I wait
Then I press "NavBack"
Then I wait to see "Security"
Then I scroll down
Then I wait to see "Authorizations (Custom UI)"
Then I press "Authorizations (Custom UI)"
Then I wait to see "Authorizations (Custom UI)"
Then I wait to see "REMOVE"
Then I press "REMOVE"
Then I wait to not see "REMOVE"
Then I press "NavBack"
Then I wait to see "WhiteLabel Demo App (Linked)"

