gem 'hoe', '>= 2.3'
require 'hoe'
require './lib/newjs'

Hoe.plugin :newgem
Hoe.plugin :website
Hoe.plugin :cucumberfeatures

Hoe.spec('newjs') do
  developer 'Dr Nic Williams', 'drnicwilliams@gmail.com'
  extra_dev_deps << ['newgem', ">= #{::Newgem::VERSION}"]
  $hoe = self
end

Dir['tasks/**/*.rake'].each { |t| load t }

task :default => [:features]
