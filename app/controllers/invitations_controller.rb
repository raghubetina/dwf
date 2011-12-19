class InvitationsController < ApplicationController
  # GET /invitations
  # GET /invitations.json
  def index
    @invitations = Invitation.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @invitations }
    end
  end

  # GET /invitations/1
  # GET /invitations/1.json
  def show
    @invitation = Invitation.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @invitation }
    end
  end

  # GET /invitations/new
  # GET /invitations/new.json
  def new
    @invitation = Invitation.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @invitation }
    end
  end

  # GET /invitations/1/edit
  def edit
    @invitation = Invitation.find(params[:id])
  end

  # POST /invitations
  # POST /invitations.json
  def create
    @invitation = Invitation.new(params[:invitation])

    respond_to do |format|
      if @invitation.save
        format.html { redirect_to @invitation, notice: 'Invitation was successfully created.' }
        format.json { render json: @invitation, status: :created, location: @invitation }
      else
        format.html { render action: "new" }
        format.json { render json: @invitation.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /invitations/1
  # PUT /invitations/1.json
  def update
    proposal = Proposal.find(params[:proposal_id])
    user = User.find(session[:user_id])
    facebook_user_id = user.facebook_user_id
    invitation = proposal.invitations.find_by_facebook_user_id(facebook_user_id)
    
    if invitation
      invitation.rsvp = params[:rsvp]
      invitation.save
    end
    
    
    yeses = proposal.invitations.select { |invitation| invitation.rsvp == "Yes" }
    
    if yeses.length == proposal.min_companions
      proposal.tipped = 1
      proposal.save
      
      deal = JSON.parse(open("https://api.groupon.com/v2/deals/#{proposal.groupon_id}.json?client_id=7da6100853a410b2713f7172cd780948216dc395").read)["deal"]
      if deal["options"][0]["redemptionLocations"].any?
        location = deal["options"][0]["redemptionLocations"][0]
        location1= nil
        if location["streetAddress1"].present?
          location1 = location["streetAddress1"]
        end
        if location["streetAddress2"].present?
          location2 = ", " + location["streetAddress2"]
        end
        if location["city"].present?
          location3 = ", " + location["city"]
        end
        if location["state"].present?
          location4 = ", " + location["state"]
        end
        if location["postalCode"].present?
          location5 = ", " + location["postalCode"]
        end
        location_string = location1.to_s + location2.to_s + location3.to_s + location4.to_s + location5.to_s
      end
      
      if proposal.proposed_datetime
        start_time = proposal.proposed_datetime.to_s
        end_time = (proposal.proposed_datetime + 10800).to_s
      else 
        start_time = (Time.new + 604800).to_s
        end_time = (Time.new + 615600).to_s
      end
      
      data = Hash.new
      
      if start_time
        data["start_time"] = start_time
        data["end_time"] = end_time
      end
      
      if location_string
       data["location"] = location_string
      end
      
      if deal["merchant"]["name"]
        data["name"] = deal["merchant"]["name"]
      end
      
      if Sanitize.clean(deal["highlightsHtml"].html_safe) + ". Website: " + deal["merchant"]["websiteUrl"].to_s
        data["description"] = Sanitize.clean(deal["highlightsHtml"].html_safe) + ". Website: " + deal["merchant"]["websiteUrl"].to_s #TODO &amp; not being cleaned
      end
      
      data["privacy_type"] = "SECRET"
      
      #TODO Error with Facebook event time -- timezone?
      uri = URI.parse("https://graph.facebook.com/me/events?access_token=#{proposal.user.facebook_access_token}")
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE

      request = Net::HTTP::Post.new(uri.request_uri)
      request.set_form_data(data)

      response = http.request(request)
      puts "-----------------------------------EVENT CREATION-----------------------------------"
      puts response
      
      proposal.facebook_event_id = JSON.parse(response.body)["id"]
      proposal.save
      
      
      logger.debug yeses
      
      yes_ids = Array.new
      yeses.each do |yes|
        yes_ids << yes.facebook_user_id
      end
      
      yes_ids = yes_ids.join(",")
      
      uri = URI.parse("https://graph.facebook.com/#{proposal.facebook_event_id}/invited?access_token=#{proposal.user.facebook_access_token}&users=#{yes_ids}")
      
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE

      request = Net::HTTP::Post.new(uri.request_uri)

      response = http.request(request)
      puts "-----------------------------------GUEST ADDITION-----------------------------------"
      puts response
      
      
      

    end

    redirect_to proposal_path(proposal)
  end

  # DELETE /invitations/1
  # DELETE /invitations/1.json
  def destroy
    @invitation = Invitation.find(params[:id])
    @invitation.destroy

    respond_to do |format|
      format.html { redirect_to invitations_url }
      format.json { head :ok }
    end
  end
end
