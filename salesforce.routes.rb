require 'clients/sfdc.tracking.client'

# A route in a sinatra web server
post '/salesforce.track' do
  salesforce = SFDC::KMTracking::Client.new

  # Check for basic authentication
  if salesforce.valid_signature?(env['HTTP_AUTHORIZATION'])
    salesforce.parse_and_record_events(request.body.read, env['HTTP_X_KM_EVENT_NAME'])
    status(200)
    body("Acknowledged")
  else
    puts "POST /salesforce.track: Signature invalid."

    status(401)
    body("Basic Authentication Failed")
  end
end
