class TodolistsController < ApplicationController
  def new
    @list = List.new
  end

  def create
    @list = List.new(list_params)
    # 投稿した本文をAPI側に渡す
    @list.score = Language.get_data(list_params[:body]) 
    # 投稿した画像をAPI側に渡す
    tags = Vision.get_image_data(list_params[:image])
    if @list.save
      # APIからの値をもとにタグを作成
      tags.each do |tag|
        @list.tags.create(name: tag)
      end
      redirect_to todolist_path(@list.id)
    else
      render :new
    end
  end

  def index
    @lists = List.all
  end

  def show
    @list = List.find(params[:id])
  end

  def edit
    @list = List.find(params[:id])
  end

  def update
    list = List.find(params[:id])
    list.update(list_params)
    redirect_to todolist_path(list.id)
  end

  def destroy
    list = List.find(params[:id])
    list.destroy
    redirect_to todolists_path
  end

  private

  def list_params
    params.require(:list).permit(:title, :body, :image)
  end

end
