Feature: Auth Request
This test checks
for the proper functionality of 
auth requests for white label

Scenario: Auth accept
Then I wait to see "Security"
Then I request an auth request
Then I press "Check For Requests"
Then I wait to see "Request"
Then I drag "auth_switch" to "login_title"
Then I wait
Then I press "NavBack"
Then I wait to see "Security"