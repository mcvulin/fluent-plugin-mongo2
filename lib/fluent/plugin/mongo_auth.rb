module Fluent
  module MongoAuthParams
    def self.included(klass)
      klass.instance_eval {
        config_param :user, :string, :default => nil
        config_param :password, :string, :default => nil, :secret => true
      }
    end
  end

  module MongoAuth
    def authenticate(client)
      unless @user.nil? || @password.nil?
        begin
          client = client.with(user: @user, password: @password)
        rescue Mongo::Auth::Unauthorized => e
          log.fatal e
          exit!
        end
      end
      client
    end
  end
end