%w[javascript_test_autotest javascript_test_ext].each do |file|
  require File.dirname(__FILE__) + "/autotest/" + file
end
