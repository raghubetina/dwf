class ProposalsController < ApplicationController
  # GET /proposals
  # GET /proposals.json
  def index
    @my_proposals = current_user.proposals
    @friends_proposals = Array.new
    Invitation.find_all_by_facebook_user_id(current_user.facebook_user_id).each do |invitation|
      @friends_proposals << invitation.proposal
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @proposals }
    end
  end

  # GET /proposals/1
  # GET /proposals/1.json
  def show
    @proposal = Proposal.find(params[:id])
    @deal = JSON.parse(open("https://api.groupon.com/v2/deals/#{@proposal.groupon_id}.json?client_id=7da6100853a410b2713f7172cd780948216dc395").read)["deal"]
    if @proposal.proposed_datetime
      @default_datetime = @proposal.proposed_datetime.strftime("%m/%d/%Y @ %l:%M %P")
    end
    @option = @deal['options'].first
    @location = @option['redemptionLocations'].first if @option['redemptionLocations'].any?
    if @location && @location["lat"] && @location["lng"]
       @coords = [ @location["lat"].to_f, @location["lng"].to_f ]
    end
    
    if @proposal.proposed_datetime
		  @placeholder = @proposal.proposed_datetime.strftime("%m/%d/%Y @ %l:%M %P")
		end
    
    @creator = @proposal.user_id
    @guests_data = Array.new
    @proposal.invitations.each do |invitation|
      @guests_data << [invitation.facebook_user_id, invitation.rsvp]
    end
    
    @guests = Array.new
    @guests_data.each do |guest_data|
      @guests << [JSON.parse(open("https://graph.facebook.com/#{guest_data[0]}").read), guest_data[1]]
    end
    
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @proposal }
    end
  end

  # GET /proposals/new
  # GET /proposals/new.json
  def new
    @proposal = Proposal.new

    @proposal.user_id = session[:user_id]
    @proposal.deal_id = params["deal_id"].to_i
    @proposal.save
    
    
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @proposal }
    end
  end

  # GET /proposals/1/edit
  def edit
    @proposal = Proposal.find(params[:id])
  end

  # POST /proposals
  # POST /proposals.json
  def create
    @proposal = Proposal.new(params[:proposal])

    respond_to do |format|
      if @proposal.save
        format.html { redirect_to @proposal, notice: 'Proposal was successfully created.' }
        format.json { render json: @proposal, status: :created, location: @proposal }
      else
        format.html { render action: "new" }
        format.json { render json: @proposal.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /proposals/1
  # PUT /proposals/1.json
  def update
    @proposal = Proposal.find(params[:id])
    
    @proposal.min_companions = params[:min_companions]
    if params[:proposal_datetimepicker].present?
      @proposal.proposed_datetime = DateTime.strptime(params[:proposal_datetimepicker], "%m/%d/%Y @ %l:%M %P")
    end
    @proposal.save

    respond_to do |format|
      if @proposal.update_attributes(params[:proposal])
        format.html { redirect_to @proposal, notice: 'Proposal was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @proposal.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /proposals/1
  # DELETE /proposals/1.json
  def destroy
    @proposal = Proposal.find(params[:id])
    @proposal.destroy

    respond_to do |format|
      format.html { redirect_to proposals_url }
      format.json { head :ok }
    end
  end
  
  def latest_invitation
    
    redirect_to proposal_path(Invitation.find_all_by_facebook_user_id(current_user.facebook_user_id).last.proposal_id)
  end
  
  def latest
    
    redirect_to proposal_path(current_user.proposals.last)
  end
  
end
