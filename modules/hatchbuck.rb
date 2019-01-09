module Hatchbuck
    class Database 

        def initialize(creds, ids) 
            @acc_id = ids[:account_id]
            @p_status_id = ids[:partner_status]
            @pc_status_id = ids[:partner_client_status]
            @fp_status_id = ids[:former_partner_status]
            @fpc_status_id = ids[:former_partner_client_status]
            @client = TinyTds::Client.new username: creds[:username], password: creds[:password], host: creds[:host], database: creds[:database]
        end

        def status_query(status_id)
            result = []
            sql = "select * from tblcontacts where accountcompanyid = #{ @acc_id } and contactstatusid = #{ status_id } and recordstatusid = 1"
            @client.execute(sql).each { |p| result.push p['ContactID'] }
            return result
        end

        def get_partners_and_clients
            { partners: status_query(@p_status_id), partner_clients: status_query(@pc_status_id) } 
        end

        def get_former_partners_and_clients
            { former_partners: status_query(@fp_status_id), former_partner_clients: status_query(@fpc_status_id) } 
        end
    end
end