Given(/^I know the time$/) do
  @time = DateTime.now
end

Given(/^there is sufficient input data for (\w+)$/) do |env|
  create_input(env)
end

Then(/^the metadata will expire in two weeks$/) do
  valid_until_value = Nokogiri::XML(all_output).at_xpath("/md:EntitiesDescriptor/@validUntil").value
  expect(valid_until_value).to_not be_nil
  valid_until = DateTime.iso8601(valid_until_value)
  expect(valid_until).to be_within(1).of(@time + 14)
end

Then(/^the Hub entity metadata will expire in two weeks$/) do
  valid_until_value = Nokogiri::XML(all_output).at_xpath("/md:EntitiesDescriptor/md:EntityDescriptor[@ID='HUB_ID']/@validUntil").value
  expect(valid_until_value).to_not be_nil
  valid_until = DateTime.iso8601(valid_until_value)
  expect(valid_until).to be_within(1).of(@time + 14)
end
