Then(/^the stderr should contain$/) do |expected|
    assert_partial_output(expected, all_stderr)
end
