module Kite
  class Configuration < Base
    include Kite::Helpers

    method_option :env, type: :string, desc: "Environment", required: true, default: ENV['KITE_ENV']
    desc 'get QUERY', 'Returns value for specified QUERY'
    def get(query)
      @env = options[:env]
      @path = cloud_path

      vars_paths = Dir[@path + "/config/environments/#{@env}/vars.*"]

      vars_paths.each do |vars_path|
        @res = YAML::load_file(vars_path)
        query.split('.').each { |k| @res = @res[k] }
        break unless @res.nil?
      end

      if @res.nil?
        raise Kite::Error, "Invalid query: \"#{query}\""
      else
        pp @res
      end
    end
  end
end
