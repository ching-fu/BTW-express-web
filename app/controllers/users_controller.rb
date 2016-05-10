class UsersController < ApplicationController

  def show
    if current_user
      @user=current_user
    else
      @user=User.first
    end
    @role=params[:role]
    #owner -> show tooken with new / old
    @owner_post=Order.listorder(@user.id,'owner',"posted").page(params[:page]).per(5)
    @owner_old=Order.listorder(@user.id,'owner',"done").page(params[:page]).per(5)
    @owner_go=Order.listorder(@user.id,'owner',"go").page(params[:page]).per(5)
    # @own_list=Order.where(:owner_id=>@user.id)
    @courier_old=Order.listorder(@user.id,'courier',"done").page(params[:page]).per(5)
    @courier_go=Order.listorder(@user.id,'courier',"go").page(params[:page]).per(5)
    # @send_list=Order.where(:courier_id=>@user.id)

  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    @user.update( user_params )
    if @user.save
      redirect_to user_path
    else
      render 'new'
    end
  end
  protected

  def user_params
    params.require(:user).permit(:fullname, :email, :phone, :introduction, :user_photo )
  end
end
