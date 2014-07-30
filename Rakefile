
begin
  require 'rake/testtask'
  Rake::TestTask.new(:test) do |test|
    puts "LANG: #{ENV['LANG']}"
    test.libs << 'test'
    test.pattern = 'test/**/*_test.rb'
    test.verbose = true
    test.warning = true
  end
  task :default => :test
rescue LoadError
end
