class PagesController < ApplicationController

  before_filter :admin_required
  
  # GET /pages
  # GET /pages.xml
  def index
    @pages = Page.find(:all)
    @page_title = tr("All pages", "controller/pages", :government_name => tr(current_government.name,"Name from database"))
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @pages }
    end
  end

  # GET /pages/new
  # GET /pages/new.xml
  def new
    @pages = Page.find(:all)
    @page = Page.new
    @page_title = tr("Create a new page", "controller/pages")
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @page }
    end
  end

  # GET /pages/1/edit
  def edit
    @pages = Page.find(:all)    
    @page = Page.find(params[:id])
    @page_title = tr("Edit title", "controller/pages")
  end

  # POST /pages
  # POST /pages.xml
  def create
    @pages = Page.find(:all)    
    @page = Page.new(params[:page])
    @page_title = tr("Create a new page", "controller/pages")
    respond_to do |format|
      if @page.save
        flash[:notice] = tr("Saved {page_name}", "controller/pages", :page_name => @page.name)
        format.html { redirect_to(about_path(@page.short_name)) }
        format.xml  { render :xml => @page, :status => :created, :location => @page }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @page.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /pages/1
  # PUT /pages/1.xml
  def update
    @pages = Page.find(:all)
    @page = Page.find(params[:id])
    @page_title = tr("Edit title", "controller/pages")
    respond_to do |format|
      if @page.update_attributes(params[:page])
        flash[:notice] = tr("Saved {page_name}", "controller/pages", :page_name => @page.name)
        format.html { render :action => "edit" }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @page.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /pages/1
  # DELETE /pages/1.xml
  def destroy
    @page = Page.find(params[:id])
    flash[:notice] = tr("Deleted {page_name}", "controller/pages", :page_name => @page.name)
    @page.destroy
    respond_to do |format|
      format.html { redirect_to(pages_url) }
      format.xml  { head :ok }
    end
  end
end
