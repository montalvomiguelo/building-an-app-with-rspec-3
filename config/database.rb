file_path = File.expand_path('../database.yml', __FILE__)
connections = YAML.load_file(file_path)

DB = Sequel.connect(connections[ENV['RACK_ENV']])
