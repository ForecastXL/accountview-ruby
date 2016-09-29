require 'bundler/gem_tasks'

task :console do
  require 'pry'
  require 'accountview'

  def reload!
    files = $LOADED_FEATURES.select { |feat| feat =~ /\/accountview\// }
    files.each { |file| load file }
  end

  ARGV.clear
  Pry.start
end
