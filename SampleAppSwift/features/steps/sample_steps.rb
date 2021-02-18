@@whiteLabelAppKey = "2021988155"
@@linkDeviceName = "Test Device"
@@linkRandomUsername = nil
@@linkCode = nil

Then /^I enter a valid linking code into field with id "([^\"]*)"$/ do |id|
  cmd = "python -c \"import random, string; print(''.join(random.SystemRandom().choice(string.ascii_uppercase + string.digits) for _ in range(8)))\""
  @@linkRandomUsername = `#{cmd}`.strip.downcase
  cmd = "python api_client.py --env prod --username #{@@linkRandomUsername} --appkey #{@@whiteLabelAppKey} create_whitelabel_user"
  puts "Cmd: #{cmd}"
  @@linkCode = `#{cmd}`.strip
  puts "Finished running"
  puts "----------------"
  puts "* Application key: #{@@whiteLabelAppKey}"
  puts "* Random username: #{@@linkRandomUsername}"
  puts "* Linking code: #{@@linkCode}"
  touch("textField marked: '#{id}'")
  wait_for_keyboard
  keyboard_enter_text @@linkCode
end


Then /^I request an auth request$/ do
    cmd = "python api_client.py --env prod --username #{@@linkRandomUsername} --appkey #{@@whiteLabelAppKey} --whitelabel True auth --policy-all 0"
    #cmd = "python api_client.py --env prod --username iosTester --appkey #{@@whiteLabelAppKey} --whitelabel True auth --policy-all 0"
    puts "Cmd: #{cmd}"
    @auth_request = `#{cmd}`.strip
    puts "Finished running"
end

Then /^I slide the switch up$/ do
    pan("* id:'launch_widget_switch'", :up)
end

Then /^I enter device name into field with id "([^\"]*)"$/ do |var|
  puts "* Device name: #{@@linkDeviceName}"
  touch("textField marked: '#{var}'")
  wait_for_keyboard
  keyboard_enter_text @@linkDeviceName
end

Then /^I name the geofence$/ do 
  keyboard_enter_text "geofence01"
end


Then /^I should see device name$/ do
  wait_for(WAIT_TIMEOUT) { view_with_mark_exists(@@linkDeviceName) }
end

Then /^I drag (\d+):(\d+) to (\d+):(\d+)/ do |fromX, fromY, toX, toY|
    
    uia("target.dragFromToForDuration({x:'#{fromX}', y:'#{fromY}'}, {x:'#{toX}', y:'#{toY}'}, 1)")    
end

Then /^I verify there was a response$/ do
        cmd = "python api_client.py --env prod --authrequest #{@auth_request} --user androidUser --appkey 4767990724 --whitelabel False authorized"
        puts "Cmd: #{cmd}"
        @auth_request = `#{cmd}`
        puts @auth_request
        puts "Finished verifying"
end

Then /^I drag "([^\"]*)" to "([^\"]*)"$/ do |from, to|
    query_from = "view marked:'#{from}'"
    query_to = "view marked:'#{to}'"
    pan query_from, query_to, duration:1
end

# python api_client.py --env prod --username iosTester --appkey 2021988155 --whitelabel True auth --policy-all 0


