require 'dotenv/load'
require 'tiny_tds'
require 'json'
require 'httparty'
require './modules/hatchbuck'
require './modules/appcues'

include Hatchbuck
include AppCues

ac_credentials = { account_id: ENV['AppCuesAccId'] }
hb_credentials = { username: ENV['HbDbUser'], password: ENV['HbDbPass'], host: ENV['HbDbHost'], database: ENV['HbDbDatabase'] }
database_ids = { 
    account_id: ENV['HbAccId'], 
    partner_status: ENV['PartnerContactStatusID'], partner_client_status: ENV['PartnerClientContactStatusID'],
    former_partner_status: ENV['FormerPartnerContactStatusID'], former_partner_client_status: ENV['FormerPartnerClientContactStatusID'] 
}

hb = Hatchbuck::Database.new(hb_credentials, database_ids)
ac = AppCues::Api.new(ac_credentials)

# { partners: [ contact_ids ], partner_clients: [ contact_ids ] }
to_suppress = hb.get_partners_and_clients

# { former_partners: [ contact_ids ], former_partner_clients: [ contact_ids ] }
to_reenable = hb.get_former_partners_and_clients

to_suppress.each do |status, ids|
    ids.each { |id| ac.update status, id }
end
