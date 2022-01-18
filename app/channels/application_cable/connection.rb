module ApplicationCable
  class Connection < ActionCable::Connection::Base
    def connect
      # reject_unauthorized_connection if cookies[:secret].nil?
    end

    def disconnect
    end
  end
end
