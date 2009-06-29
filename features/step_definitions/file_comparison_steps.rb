Then /^file '(.*)' is same as file '(.*)'/ do |file1, file2|
  in_project_folder do
    File.exists?(file1)
    File.exists?(file2)
    file1_contents = File.read(file1)
    file2_contents = File.read(file2)
    file1_contents.should == file2_contents
  end
end

