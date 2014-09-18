I combine a simple web server (which I'll call the "Forwarding Webserver") hosted on Heroku with Salesforce Apex to have KISSmetrics track certain actions done in Salesforce. Currently, we're tracking when a lead is created and converted, and when an opportunity is won or lost.

The workflow looks like this:

* When a Lead is created...
* ...an Apex trigger runs...
* ...which makes a web callout to your web server, with information about the Lead(s) that were just created.
* The forwarding web server then receives information about the Lead(s)...
* ...and for each Lead...
* ...the web server uses the KISSmetrics Tracking API to track that the lead was created.

# The Forwarding Webserver

Today, this is a Sinatra web server hosted on Heroku.

1. Set up the route (`lib/routes/salesforce.routes.rb`)
2. Set up the client (`lib/clients/sfdc.tracking.client.rb`)
3. Set up the models (`lib/models/sfdc.event.rb`, `lib/models/sfdc.sobject.rb`)
4. Deploy!
5. You will need the URL of the route for the next step. 

# Within Salesforce

I have access to the Salesforce sandbox, which is required in order to add Apex classes.

1. Add apex classes, test factory, and tests.
  * Setup -> Develop -> Apex Classes
  * `KMTracking.cls`
  * `KMTrackingLeadTest.cls`
  * `KMTrackingOpportunityTest.cls`
  * `TestFactory.cls`

2. Add triggers.
  * Setup -> Customize -> Opportunities -> Triggers
    * `KMTrackOpportunityClose.trigger`
  * Setup -> Customize -> Leads -> Triggers
    * `KMTrackLeadCreation.trigger`
	* `KMTrackLeadConversion.trigger`

3. Add the URL of the forwarding webserver to Setup -> Security Controls -> Remote Site Settings.

4. When ready, add all of the above to an Outbound Change Set and deploy from sandbox to production.