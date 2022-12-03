require 'pathname'

%w(input lib solve test).each do |lib|
  lib = Pathname.getwd / lib
  $LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
end

def files lib
  lib   = Pathname.getwd / lib
  paths = lib.each_child.select { |child| child.extname == ".rb" }
  paths.map { |path| path.basename.to_s }.sort
end

def most_recent_day lib
  files(lib).map { |file| file.scan(/\d\d/).first.to_i }.max
end

task :test, [:day] do |task, args|
  args.with_defaults :day => most_recent_day("test")
  day   = args[:day].to_i
  file  = "day_%02d_test.rb" % day
  require file
end

task :solve, [:day] do |task, args|
  args.with_defaults :day => most_recent_day("solve")
  day   = args[:day].to_i
  file  = "day_%02d_solve.rb" % day
  require file
end

task :test_all do |task|
  files("test").each { |file| require file }
end

task :solve_all do |task|
  files("solve").each { |file| require file }
end

task :all do |task|
  (files("test") + files("solve")).sort.each { |file| require file }
end

task :default => :all
