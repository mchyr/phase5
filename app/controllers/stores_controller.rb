class StoresController < ApplicationController

  before_filter :check_login, :except => [:show]

  def index
    @stores = Store.active.alphabetical.paginate(:page => params[:page]).per_page(10)
    @inactive_stores = Store.inactive.alphabetical.paginate(:page => params[:inactive_page]).per_page(10)
  end

  def show
    @store = Store.alphabetical.find(params[:id])
    @employees = @store.assignments.current.paginate(:page => params[:page]).per_page(10)
    authorize! :show, @store
    # get all the current assignments for this store
    @current_assignments = @store.assignments.current.by_employee.paginate(:page => params[:page]).per_page(8)
  end

  def new
    @store = Store.new
    authorize! :new, @store
  end

  def edit
    @store = Store.find(params[:id])
    authorize! :edit, @store
  end

  def create
    @store = Store.new(params[:store])
    authorize! :create, @store
    if @store.save
      # if saved to database
      flash[:notice] = "Successfully created #{@store.name}."
      redirect_to @store # go to show store page
    else
      # return to the 'new' form
      render :action => 'new'
    end
  end

  def update
    @store = Store.find(params[:id])
    authorize! :update, @store
    if @store.update_attributes(params[:store])
      flash[:notice] = "Successfully updated #{@store.name}."
      redirect_to @store
    else
      render :action => 'edit'
    end
  end

  def destroy
    @store = Store.find(params[:id])
    authorize! :destroy, @store
    @store.destroy
    flash[:notice] = "Successfully removed #{@store.name} from the Creamery system."
    redirect_to stores_url
  end
end
