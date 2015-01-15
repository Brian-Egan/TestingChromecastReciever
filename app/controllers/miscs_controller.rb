class MiscsController < ApplicationController
  before_action :set_misc, only: [:show, :edit, :update, :destroy]

  # before_filter :restrict_access

  # GET /miscs
  # GET /miscs.json
  def index
    @miscs = Misc.all unless request.format == "json"

    # puts request.format
    if request.format == "json"
      if params[:ios]
        @misc = Misc.create
      else
        @misc = (Misc.count == 0) ? Misc.create : Misc.last
      end
      # render :json
      render :show, location: @misc
    end
  end

  # GET /miscs/1
  # GET /miscs/1.json
  def show
    @misc = (Misc.count == 0) ? Misc.create : Misc.last
    puts "We created a misc at #{@misc}"
    # @misc = Misc.last
    respond_to do |format|
      format.html { redirect_to @misc, notice: 'Misc was successfully created.' }
      format.json { render :show, location: @misc }
    end
  end

  # GET /miscs/new
  def new
    @misc = Misc.new
  end

  # GET /miscs/1/edit
  def edit
  end

  # POST /miscs
  # POST /miscs.json
  def create
    # @misc = Misc.new(misc_params)
    # @misc = Misc.new(babble:  (0...6).map { (65 + rand(26)).chr }.join)
    @misc = Misc.new
    respond_to do |format|
      if @misc.save
        format.html { redirect_to @misc, notice: 'Misc was successfully created.' }
        format.json { render :show, status: :created, location: @misc }
      else
        format.html { render :new }
        format.json { render json: @misc.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /miscs/1
  # PATCH/PUT /miscs/1.json
  def update
    respond_to do |format|
      if @misc.update(misc_params)
        format.html { redirect_to @misc, notice: 'Misc was successfully updated.' }
        format.json { render :show, status: :ok, location: @misc }
      else
        format.html { render :edit }
        format.json { render json: @misc.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /miscs/1
  # DELETE /miscs/1.json
  def destroy
    @misc.destroy
    respond_to do |format|
      format.html { redirect_to miscs_url, notice: 'Misc was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_misc
      @misc = Misc.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def misc_params
      params.require(:misc).permit(:babble)
    end

    def restrict_access
          puts "Checking auth token"
          authenticate_or_request_with_http_token do |token, options|
            if token == "abcdef1234"
              puts "What kind of idiot would use that password?!"
              return true
            else
              return false
            end
          end
    end
end
