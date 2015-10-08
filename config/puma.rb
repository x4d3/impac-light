require 'rbconfig'
#http://stackoverflow.com/questions/4871309/what-is-the-correct-way-to-detect-if-ruby-is-running-on-windows
is_windows = (RbConfig::CONFIG['host_os'] =~ /mswin|mingw|cygwin/)
if is_windows
	puts "windows detected, cluster not activated"
else
	#puma does not support cluster on windows http://stackoverflow.com/questions/20801734/error-while-starting-puma-server-with-workers
	workers Integer(ENV['WEB_CONCURRENCY'] || 2)
end

threads_count = Integer(ENV['MAX_THREADS'] || 5)
threads threads_count, threads_count

preload_app!

rackup      DefaultRackup
port        ENV['PORT']     || 3000
environment ENV['RACK_ENV'] || 'development'
