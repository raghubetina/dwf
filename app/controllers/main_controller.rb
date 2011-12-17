
class MainController < ApplicationController
  def index
    
  end
  
  def facebook_requests_dialog_callback
  end
  
  # TODO Use Real-Time Updates to keep data fresh
  def facebook_auth_response_callback
    facebook_user_id = params[:facebook_user_id]
    facebook_access_token = params[:facebook_access_token]
    if user = User.find_by_facebook_user_id(facebook_user_id)
      # existing user
    else
      user = User.new
      response = JSON.parse(open("https://graph.facebook.com/me?access_token=#{facebook_access_token}").read)
      user.facebook_user_id = response["id"]      
      user.first_name = response["first_name"]      
      user.last_name = response["last_name"]      
      user.location_id = response["location"]["id"]      
      user.location_name = response["location"]["name"]     
      user.gender = response["gender"]      
      user.timezone = response["timezone"]      
      user.updated = response["updated"]
    end
    
    user.facebook_access_token = facebook_access_token
    user.save
    session[:user_id] = user.id
  end
  
  def test_requests
  end
  
  def deals
    @deals = JSON.parse(open("https://api.groupon.com/v2/deals.json?client_id=7da6100853a410b2713f7172cd780948216dc395&show=title,announcementTitle,grid4ImageUrl,sidebarImageUrl,grid6ImageUrl,options,highlightsHtml").read)["deals"]
  end
  
  def deals_layout
    
  end
  
  def deal_detail
    deal_id = params[:deal_id]
    @deal = JSON.parse(open("https://api.groupon.com/v2/deals/#{deal_id}.json?client_id=7da6100853a410b2713f7172cd780948216dc395").read)["deal"]
    
  end
  
end
