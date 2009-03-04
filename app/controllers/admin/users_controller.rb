class Admin::UsersController < Admin::AdminController
	
	before_filter :find_user, :only => [ :edit, :update, :show, :destroy, :delete_image ]

	def list
		redirect_to :action => "index"
	end
	
	def index
		respond_to do |format|
			format.html do 
				@users = User.find( :all, :order => 'is_activated DESC, realname' )
			end
			format.xml do
				@users = User.find( :all )
				render :xml => @users.to_xml
			end
		end
	end

	def welcome
		if User.count < 1
			flash.now[:notice] = nil # TODO: fiks hack
			if request.get?
				@user = User.new
			else
				@user = User.new( params[:user].merge( { :is_admin => true, :is_activated => true } ) )
				@user.save
				@current_user = @user
				@current_user.last_login_at = Time.now
				@current_user.save
				session[:user_id] = @current_user.id
				redirect_to :controller => 'pages' and return
			end
		else
			raise "Account holder already created"
		end
	end
	
	def new_password
		if params[:username]
			if user = User.find_by_username_or_email( params[:username] )
				new_password = user.generate_new_password
				user.save
				AdminMailer.deliver_new_password( :user => user, :site_name => PagesCore.config( :site_name ), :password => new_password, :login_url => url_for( :controller => 'admin/pages', :action => :index, :only_path => false ) )
				flash[:notice] = "A new password has been sent to your email address"
				redirect_to "/admin" and return
			end
		end
	end
	
	def login
		redirect_to admin_default_url
	end
	
	def logout
		flash[:notice] = "You have been logged out."
		deauthenticate!( :forcefully => true )
		redirect_to( "/admin" ) and return
	end
	
	def new
		@user = User.new
		@user.is_admin     = true
		@user.is_activated = true
	end
	
	def create
		@user = User.new( params[:user] )
		@user.creator  = @current_user
		if @user.save
			AdminMailer.deliver_new_user( :user => @user, :site_name => PagesCore.config( :site_name ), :login_url => url_for( :controller => 'admin/pages', :action => :index, :only_path => false ) )
			flash[:notice] = "#{@user.realname} has been invited."
			redirect_to :action => :index
		else
			flash.now[:error] = "There were problems inviting this person."
			render :action => :new
		end
	end
	
	def show
		respond_to do |format|
			format.html
			format.xml { render :xml => @user.to_xml }
		end
	end
	
	def edit
		unless @user.editable_by? @current_user
			flash[:error] = "Only the account holder can edit this person"
			redirect_to admin_user_path( @user ) and return
		end
	end
	
	def update
		unless @user.editable_by? @current_user
			flash[:error] = "Only the account holder can edit this person"
			redirect_to admin_user_path( @user ) and return
		end
		original_username = @user.username
		if @user.update_attributes( params[:user] )
			# Send an email notification if the username or password changes
			if ( params[:user][:username] && params[:user][:username] != original_username ) || ( params[:user][:password] && !params[:user][:password].blank? )
				AdminMailer.deliver_user_changed( 
					:user       => @user, 
					:site_name  => PagesCore.config( :site_name ), 
					:login_url  => url_for( :controller => 'admin/pages', :action => :index, :only_path => false ),
					:updated_by => @current_user
				)
			end
			flash[:notice] = "Your changed to #{@user.realname} were saved."
			@current_user = @user if @user == @current_user
			redirect_to admin_users_path
		else
			flash.now[:error] = "There were problems saving your changes."
			render :action => :edit
		end
	end
	
	def destroy
		unless @user.editable_by? @current_user
			flash[:error] = "Only the account holder can edit this person"
			redirect_to admin_user_path( @user ) and return
		end
		@user = User.find( params[:id] )
		flash[:notice] = "User <strong>#{@user.username}</strong> has been deleted"
		@user.destroy
		redirect_to :action => :list
	end
	
	def delete_image
		unless @user.editable_by? @current_user
			flash[:error] = "Only the account holder can edit this person"
			redirect_to admin_user_path( @user ) and return
		end
		@user.image.destroy
		respond_to do |format|
			format.js   { render :text => "The profile picture has been deleted." }
			format.html { redirect_to( edit_admin_user_path( @user ) ) }
		end
	end
	
	private
	
		def find_user
			@user = User.find( params[:id] )
		end
end
