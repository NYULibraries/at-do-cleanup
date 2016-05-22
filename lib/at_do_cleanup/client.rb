require 'mysql2'

module ATDOCleanup
  class Client
    def self.new(config = Config.new)
      # connect to db
      Mysql2::Client.new(host:     config.host,
                         username: config.user,
                         password: config.pass,
                         database: config.database)
    end
  end
end
