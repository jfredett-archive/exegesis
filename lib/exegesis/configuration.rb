module Exegesis
  class Configuration
    extend Forwardable

    def initialize(base_directory, searcher = FileSearcher)
      @searcher = searcher
      @base_directory = case base_directory
                        when String # assume it's a path to a directory
                          BaseDirectory.new(base_directory)
                        when BaseDirectory # use it
                          base_directory
                        when Directory # grab it's path and make it a base directory
                          BaseDirectory.new(base_directory.path)
                        else # assume they gave us something that will work
                          base_directory
                        end
    end
    attr_reader :searcher, :base_directory

    delegate [:valid?, :invalid?, :errors] => :validation

    def config
      # read the file, build the project AST from it.
      @config ||= eval base_directory.find_file('exegesis').content
    end

    def validate!
      @validation ||= AST::Validator.new.tap do |validator|
        config.visit(validator)
      end
    end
    alias validation validate!
  end
end
