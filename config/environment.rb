# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Engaccino::Application.initialize!

# Load String extended features
require 'assets/string_extended'