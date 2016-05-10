class OrdersController < ApplicationController

  before_action :authenticate_user!, :except => [:index,:show]
  before_action :find_order, :only => [:show,:take,:reject,:destroy,:update]
  def index
      @orders = Order.includes(:detail).all.order('created_at DESC')
  end

  def show
  end

  def new
    @order = Order.new
    @order.build_detail( description: params[:description] )
  end
  def update
    @order.status="done"
    @order.save
    redirect_to orders_path
  end

  def create
    @order = Order.create(order_params)
    @order.owner_id=current_user.id
    @order.status="posted"

    if @order.save
      redirect_to order_url(@order)
    else
      render 'new'
    end
  end
  def take
    # puts 'enter take'
    @order.courier_id=current_user.id
    @order.status="go"
    if @order.save
      render 'show'
    end
  end
  def reject
    # puts 'enter reject'
    @order.courier_id=nil
    if @order.save
      render 'show'
    end
  end
  def destroy
    puts "enter delete"
    if @order.courier_id!=nil
      # if this order is tooken by someone, notice him
    end
    @order.destroy
    # puts @order.destroyed?
    redirect_to orders_path
  end

  # def update
  #   if params[:destory_photo]
  #   @order.photo = nil
  # end

  #   if @order.update( order_params )
  #     redirect_to order_url(@order)
  #   else
  #     render "edit"
  #   end
  # end

private
  def find_order
      @order= Order.includes(:detail).find(params[:id])
  end
  def order_params
    params.require(:order).permit( :pickup_time, :deliver_time, :pickup_addr,
      :deliver_addr, :category, :owner_id, :courier_id, :status, :photo,
      detail_attributes:[:prepay, :fee, :addressees_mobile, :addressees_name, :description] )
  end


end
