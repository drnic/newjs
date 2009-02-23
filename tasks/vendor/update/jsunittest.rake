namespace 'vendor' do
  namespace 'update' do
    desc "Generates the latest jsunittest dist files into all the generators"
    task :jsunittest do
      require "fileutils"
      FileUtils.mkdir_p(cache = "/tmp/jsunittest")
      target_folders = `find * -name jsunittest.js | grep -v "^vendor" | sed -e "s/jsunittest.js$//"`.split("\n")

      sh "cd vendor/jsunittest && rake dist"

      %w[jsunittest.js unittest.css].each do |f|
        target_folders.each do |folder|
          FileUtils.cp "vendor/jsunittest/dist/#{f}", folder
        end
      end
    end
  end
end
