namespace 'vendor' do
  namespace 'update' do
    desc "Generates the latest jshoulda dist files into all the generators"
    task :jshoulda do
      require "fileutils"
      FileUtils.mkdir_p(cache = "/tmp/jshoulda")
      target_folders = `find * -name jshoulda.js | grep -v "^vendor" | sed -e "s/jshoulda.js$//"`.split("\n")

      sh "cd vendor/jshoulda && rake dist"

      %w[jshoulda.js unittest.css].each do |f|
        target_folders.each do |folder|
          FileUtils.cp "vendor/jshoulda/dist/#{f}", folder
        end
      end
    end
  end
end
