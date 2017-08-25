Given(/^there a directory called working$/) do
  create_dir("working")
end

Given(/^there is an environment called local in working$/) do
  create_dir(File.join("working", "local"))
end

Given(/^local in working has a source file describing the hub$/) do
  write_file_describing_hub(File.join("working", "local"))   
end

Given(/^local in working has some idps defined$/) do
  write_default_idps(File.join("working", "local"))   
end
