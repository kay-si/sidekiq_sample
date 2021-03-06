require 'net/https'
require './app/workers/pygment_worker.rb'

class SnippetsController < ApplicationController
  before_action :set_snippet, only: [:show, :edit, :update, :destroy]

  # GET /snippets
  # GET /snippets.json
  def index
    @snippets = Snippet.all
  end

  # GET /snippets/1
  # GET /snippets/1.json
  def show
  end

  # GET /snippets/new
  def new
    @snippet = Snippet.new
  end

  # GET /snippets/1/edit
  def edit
  end

 # POST /snippets
 # POST /snippets.json
 # 修正後のcreateメソッド
 #def create
 #  @snippet = Snippet.new(snippet_params)
 #  respond_to do |format|
 #    if @snippet.save
 #      PygmentWorker.perform_async(@snippet.id)
 #      format.html { redirect_to @snippet, notice: 'Snippet was successfully created.' }
 #      format.json { render :show, status: :created, location: @snippet }
 #    else
 #      format.html { render :new }
 #      format.json { render json: @snippet.errors, status: :unprocessable_entity }
 #    end
 #  end
 #end

  # workerで動かす前のcreateメソッド
  # 修正後のcreateメソッド
  def create
    @snippet = Snippet.new(snippet_params)  
    respond_to do |format|
      if @snippet.save
        uri = URI.parse("https://pygments.simplabs.com/")
        request = Net::HTTP.post_form(uri, lang: @snippet.language, code: @snippet.plain_code)
        @snippet.update_attribute(:highlighted_code, request.body)
        format.html { redirect_to @snippet, notice: 'Snippet was successfully created.' }
        format.json { render :show, status: :created, location: @snippet }
      else
        format.html { render :new }
        format.json { render json: @snippet.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /snippets/1
  # PATCH/PUT /snippets/1.json
  def update
    respond_to do |format|
      if @snippet.update(snippet_params)
        format.html { redirect_to @snippet, notice: 'Snippet was successfully updated.' }
        format.json { render :show, status: :ok, location: @snippet }
      else
        format.html { render :edit }
        format.json { render json: @snippet.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /snippets/1
  # DELETE /snippets/1.json
  def destroy
    @snippet.destroy
    respond_to do |format|
      format.html { redirect_to snippets_url, notice: 'Snippet was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_snippet
      @snippet = Snippet.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def snippet_params
      params.require(:snippet).permit(:language, :plain_code, :highlighted_code)
    end
end
