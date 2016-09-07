require 'bundler/gem_tasks'

task :console do
  require 'pry'
  require 'accountview'

  def reload!
    # Change 'gem_name' here too:
    files = $LOADED_FEATURES.select { |feat| feat =~ /\/accountview-ruby\// }
    files.each { |file| load file }
  end

  ARGV.clear
  Pry.start
end
