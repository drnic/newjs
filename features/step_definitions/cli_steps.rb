When /^I run newjs_screwunit for project "(.*)" with options "(.*)"$/ do |project_name, arguments|
  @cmd = File.expand_path(File.dirname(__FILE__) + "/../../bin/newjs_screwunit")
  setup_active_project_folder(project_name)
  in_tmp_folder do
    @stdout = File.expand_path("cli.out")
    system "ruby #{@cmd} #{arguments} #{project_name} > #{@stdout}"
    force_local_lib_override
  end
end
