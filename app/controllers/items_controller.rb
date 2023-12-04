class ItemsController < ApplicationController

  def index
    @item = Item.all
    render json: @item
  end

  def show 
    @item = Item.find_by(id: params[:id])
    render json: @item
  end

  def create
    @item = Item.new(item_params)
    if @item.save
      render json: @item, status: :created
    else
      render json: { errors: @item.errors.full_messages },
      status: :unprocessable_entity
    end
  end

  def soft_delete
    @item = Item.find_by(id: params[:id])
    @item.soft_delete
    render json: @item
  end



  def restore
    @item = Item.only_deleted.find_by(id: params[:id])
    if @item
      @item.restore
      render json: { message: "Item restored", item: @item }
    else
      render json: { error: "Item not found or not soft deleted" }, status: :not_found
    end
  end
  

  private

  def item_params
    params.permit(:name)
  end


end
