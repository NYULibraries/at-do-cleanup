module ATDOCleanup
  # class encapsulates database configuration information
  class Config
    attr_reader :host, :user, :pass, :database
    def initialize
      # extract database connection parameters from environment
      @host     = ENV['AT_DB_HOST']     || 'localhost'
      @user     = ENV['AT_DB_USER']     || 'root'
      @pass     = ENV['AT_DB_PASSWORD'] || ''
      @database = ENV['AT_DB_DATABASE']
      unless database
        raise 'ERROR: please set AT_DB_DATABASE environment variable'
      end
    end
  end
end
