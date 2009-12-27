class Admin::AuthorsController < Admin::BaseController
  layout 'admin'

  before_filter :admin_check, :only => [:new, :create, :destroy]

  def index
    @authors = Author.all
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @authors }
    end
  end

  def show
    @author = Author.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @author }
    end
  end

  def new
    @author = Author.new
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @author }
    end
  end

  def edit
    @author = Author.find(params[:id])
    admin_check(@author)
  end

  def create
    @author = Author.new(params[:author])
    respond_to do |format|
      if @author.save
        flash[:notice] = 'Author was successfully created.'
        format.html { redirect_to(admin_author_path(@author)) }
        format.xml  { render :xml => admin_author_path(@author), :status => :created, :location => admin_author_path(@author) }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @author.errors, :status => :unprocessable_entity }
        # TODO: Verify that this format.xml will work
      end
    end
  end

  def update
    @author = Author.find(params[:id])
    admin_check(@author)
    @author.admin = params[:author][:admin] if current_author.admin?
    respond_to do |format|
      if @author.update_attributes(params[:author])
        flash[:notice] = 'Author was successfully updated.'
        format.html { redirect_to(admin_author_path(@author)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @author.errors, :status => :unprocessable_entity }
        # TODO: Verify this xml render will work
      end
    end
  end

  def destroy
    @author = Author.find(params[:id])
    @author.destroy
    respond_to do |format|
      format.html { redirect_to(admin_authors_url) }
      format.xml  { head :ok }
    end
  end

  private

  def admin_check(author = nil)
    unless current_author.admin? || author == current_author
      redirect_to admin_authors_path
      flash[:notice] = "You do not have permission to view this resource.  Please contact the blog owner."
    end
  end

end

