Feature: Using Time-based One-Time Passwords with Default UI

  Scenario: As an implementer, I want to 
  allow users to use whatever T-OTPs they
  have in the application using the WL
  SDK and its default Views.
  
Then I wait to see "Linking (Default Manual)"
Then I scroll down
Then I scroll down
Then I press "OTP"
Then I wait to see "Add a new token"
Then I press "Manual entry"
Then I wait to see "Add Token"
Then I enter "TokenCompany" into the "enterotp_account" text field
Then I wait to see "Cancel"
Then I enter "Username" into the "enterotp_issuer" text field
Then I wait to see "Cancel"
Then I press "Done"
Then I wait to see "Error"
Then I press "OK"
Then I enter "thisthisthisthis" into the "enterotp_secret" text field
Then I press "Done"
Then I wait to see "Tokens"
Then I wait
Then I press "Username"
Then I press "Back"
Then I wait to see "WhiteLabel Demo App (Linked)"


Scenario: Token Edit
Then I wait to see "WhiteLabel Demo App (Linked)"
Then I scroll down
Then I scroll down
Then I press "OTP"
Then I wait to see "Tokens"
Then I drag "token_label" to "username_label"
Then I wait to see "Tokens"
Then I press "edit"
Then I wait to see "Edit Token"
Then I press "Cancel"
Then I wait to see "Tokens"
Then I drag "token_label" to "username_label"
Then I wait to see "Tokens"
Then I press "edit"
Then I wait to see "Edit Token"
Then I press "enterotp_issuer"
Then I clear text field number 1
Then I enter "badabing" into the "enterotp_issuer" text field
Then I wait to see "Edit Token"
Then I press "enterotp_account"
Then I clear text field number 2
Then I enter "peoplegmail.com" into the "enterotp_account" text field
Then I wait to see "Edit Token"
Then I press "action_done"

Scenario: Token Delete
Then I wait to see "WhiteLabel Demo App (Linked)"
Then I scroll down
Then I scroll down
Then I press "OTP"
Then I wait to see "Tokens"
Then I drag "token_label" to "username_label"
Then I wait to see "Tokens"
Then I press "delete"
Then I wait to see "Tokens"
Then I press "Back"
Then I wait to see "WhiteLabel Demo App (Linked)"
