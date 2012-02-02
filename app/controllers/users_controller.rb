class UsersController < ApplicationController
  before_filter :authenticate, :except => [:show, :new, :create]
  before_filter :correct_user, :only => [:edit, :update]
  before_filter :admin_user,   :only => :destroy
  before_filter :redirect_signed_in,  :only => [:new, :create]
  
  def index
    @title="All users"
    @users = User.paginate(:page => params[:page])
  end
  
  def show
    @user=User.find(params[:id])
    @microposts = @user.microposts.paginate(:page => params[:page])
    @title=@user.name
  end
  
  def new
    @user=User.new
    @title="Sign up"
  end
  
  def create
    @user = User.new(params[:user])
    if @user.save
      sign_in @user
      flash[:success]="Welcome to the Sample App!"
      redirect_to @user #user_path(@user)
    else
      @title = "Sign up"
      render 'new'
    end
  end
  
  def edit
    @title="Edit user"
  end
  
  def update
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile updated."
      redirect_to @user
    else
      @title = "Edit user"
      render 'edit'
    end
  end
  
  def destroy
    if current_user!=User.find(params[:id])
      User.find(params[:id]).destroy
      flash[:success] = "User destroyed."
      redirect_to users_path
    else
      redirect_to users_path
    end
  end
  
 def following
    show_follow(:following)
  end

  def followers
    show_follow(:followers)
  end

  def show_follow(action)
    @title = action.to_s.capitalize
    @user = User.find(params[:id])
    @users = @user.send(action).paginate(:page => params[:page])
    #send(action) �������� ����� followers(ing) ��� @user
    render 'show_follow'
  end

  private
    
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end
    
    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end
    
    def redirect_signed_in
      redirect_to(root_path) if signed_in?
    end
    
end
