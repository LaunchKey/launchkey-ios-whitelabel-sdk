Feature: Unlinking device

  Scenario: As an implementer, I want to 
  allow users to unlink their devices 
  whenever they want.
  
Then I wait to see "Linking (Default Manual)"
Then I scroll down
Then I wait to see "Devices (Default UI)"
Then I press "Devices (Default UI)"
Then I wait to see "Current Device:"
Then I press "UNLINK"
Then I wait to see "Unlink this device?"
Then I press "Cancel"
Then I wait to see "UNLINK"
Then I press "UNLINK"
Then I wait to see "Unlink this device?"
Then I press "Unlink"
Then I wait to see "WhiteLabel Demo App (Unlinked)"


Scenario: Link device again
Then I wait to see "Linking (Default Manual)"
Then I press "Linking (Custom Manual)"
Then I wait to see "LINK"
Then I enter device name into field with id "device_name"
Then I enter a valid linking code into field with id "link_text_field"
Then I wait
Then I press "link" 
Then I wait to see "Linking (Default Manual)"

Scenario: Devices (Custom UI)
Then I wait to see "Security"
Then I scroll down 
Then I wait to see "Devices (Custom UI)"
Then I press "Devices (Custom UI)"
Then I wait to see "UNLINK"
Then I press "UNLINK"
Then I wait to see "Unlink this device?"
Then I press "Cancel"
Then I should see "UNLINK"
Then I press "UNLINK"
Then I wait to see "Unlink"
Then I press "Unlink"
Then I wait to see "WhiteLabel Demo App (Unlinked)"

