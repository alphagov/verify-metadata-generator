When(/^the metadata is generated for (\w+) with (\d+) days of validity$/) do |env, days|
    run_simple("generate_metadata -e #{env} --valid-until=#{days}")
end

Then(/^the metadata will expire in (\d+) days$/) do |days|
    valid_until_value = Nokogiri::XML(all_output).at_xpath("/md:EntitiesDescriptor/@validUntil").value
    expect(valid_until_value).to_not be_nil
    valid_until = DateTime.iso8601(valid_until_value)
    expect(valid_until).to be_within(1).of(@time + Integer(days))
end
