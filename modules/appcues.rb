module AppCues
    class Api
        def initialize(creds) 
            @base_url = "https://api.appcues.net/v1/accounts/#{ creds[:account_id] }/users/$user_id/activity"
        end

        def update(status, id)
            endpoint = @base_url.gsub('$user_id', id.to_s)
            puts "Changing id #{id} to #{status} @#{endpoint}"
        end
    end
end