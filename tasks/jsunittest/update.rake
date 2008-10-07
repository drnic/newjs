namespace 'jsunittest' do
  desc "Updates the jsunittest.js assets in generators"
  task :update do
    require "fileutils"
    FileUtils.mkdir_p(cache = "/tmp/jsunittest")
    target_folders = 
      `find * -name jsunittest.js | sed -e "s/jsunittest.js$//"`.split("\n")
    path = "http://jsunittest.com/dist/jsunittest-getting-started/assets/"
    %w[jsunittest.js unittest.css].
      each do |f|
        sh "curl -o #{cache}/#{f} #{path}#{f}"
        
        target_folders.each do |folder|
          FileUtils.cp "#{cache}/#{f}", folder
        end
      end
  end
end
