
class MainController < ApplicationController
  def index
    
  end
  
  def facebook_notification_callback
    # request_ids_string = params[:request_ids]
    # request_ids = request_ids_string.split(",").collect{ |s| s.to_i }
    # 
    # request_ids.each do |request_id|
    #   uri = URI.parse("https://graph.facebook.com/#{request_id+"_"+current_user.facebook_user_id}?access_token=#{current_user.facebook_access_token}")
    # 
    #   http = Net::HTTP.new(uri.host, uri.port)
    #   http.use_ssl = true
    #   http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    # 
    #   request = Net::HTTP::Delete.new(uri.request_uri)
    # 
    #   response = http.request(request)
    #   puts "-----------------------------------NOTIFICATION DELETION-----------------------------------"
    #   puts response
    # end
    # 
    # 
  end
  
  def facebook_requests_dialog_callback    
    proposal = Proposal.new
    proposal.user_id = session[:user_id]
    proposal.groupon_id = params["groupon_id"]
    proposal.save
    
    guest_ids = params["guest_ids"]
    guest_ids.each do |guest_id|
      invitation = Invitation.new
      invitation.proposal_id = proposal.id
      invitation.facebook_user_id = guest_id.to_i
      invitation.facebook_request_id = params["request_id"]
      invitation.save
    end
  end
  
  # TODO Use Real-Time Updates to keep data fresh
  def facebook_auth_response_callback
    if params["unknown"]
      reset_session
    else
      facebook_user_id = params[:facebook_user_id]
      facebook_access_token = params[:facebook_access_token]
      if user = User.find_by_facebook_user_id(facebook_user_id)
        # existing user
      else
        user = User.new
        response = JSON.parse(open("https://graph.facebook.com/me?access_token=#{facebook_access_token}").read)
        user.facebook_user_id = facebook_user_id
        if response["first_name"] 
          user.first_name = response["first_name"]     
        end
        if response["last_name"] 
          user.last_name = response["last_name"]    
        end  
        #TODO Clean this up
        if response["location"] && response["location"]["id"] 
          user.location_id = response["location"]["id"]  
        end    
        if response["location"] && response["location"]["name"]
          user.location_name = response["location"]["name"]
        end  
        if response["gender"]
          user.gender = response["gender"] 
        end     
        if response["timezone"]
          user.timezone = response["timezone"]
        end    
        if response["updated"]
          user.updated = response["updated"]
        end
      end
    
      user.facebook_access_token = facebook_access_token
      user.save
      session[:user_id] = user.id
    end
  end
  
  def test_requests
  end
  
  def deals
    # if params[:request_ids]
    #   request_ids_string = params[:request_ids]
    #   request_ids = request_ids_string.split(",").collect{ |s| s.to_i }
    # 
    #   request_ids.each do |request_id|
    #     uri = URI.parse("https://graph.facebook.com/#{request_id.to_s+"_"+current_user.facebook_user_id.to_s}?access_token=#{current_user.facebook_access_token}")
    # 
    #     http = Net::HTTP.new(uri.host, uri.port)
    #     http.use_ssl = true
    #     http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    # 
    #     request = Net::HTTP::Delete.new(uri.request_uri)
    # 
    #     response = http.request(request)
    #     puts "-----------------------------------NOTIFICATION DELETION-----------------------------------"
    #     puts response
    #   end
    # else
  
  
  
    @deals = JSON.parse(open("https://api.groupon.com/v2/deals.json?client_id=7da6100853a410b2713f7172cd780948216dc395&division_id=chicago&show=title,announcementTitle,grid4ImageUrl,sidebarImageUrl,grid6ImageUrl,options,highlightsHtml").read)["deals"]

  
  
  end
  
  def deals_layout
    
  end
  
  def deal_detail
    deal_id = params[:deal_id]
    @deal = JSON.parse(open("https://api.groupon.com/v2/deals/#{deal_id}.json?client_id=7da6100853a410b2713f7172cd780948216dc395").read)["deal"]
    @option = @deal["options"].first
    @location = @option["redemptionLocations"].first if @option["redemptionLocations"].any?
    if @location && @location["lat"] && @location["lng"]
       @lat = @location["lat"].to_f 
       @lng = @location["lng"].to_f
    end
  end
  
end
