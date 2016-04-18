# This file is used by Rack-based servers to start the application.

require ::File.expand_path('../config/environment', __FILE__)
$stdout.sync = true
config.logger = Logger.new(STDOUT)
run Rails.application
