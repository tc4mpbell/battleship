# using this file to load anything an application file may need

ROOT = File.expand_path '../..', __FILE__

# load all gems
require 'timeout'

# load all lib files
Dir.glob(File.join(ROOT, 'lib/*.rb')).each do |model_file|
  require model_file
end

# load all player files
Dir.glob(File.join(ROOT, 'players/**/*.rb')).each do |model_file|
  require model_file
end
