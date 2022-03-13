class BooksController < ApplicationController

  before_action :authenticate_user!

  before_action :ensure_current_user, {only: [:edit,:update,:destroy]}

  def create
    @book = Book.new(book_params)
    @book.user_id = current_user.id
    if @book.save
      redirect_to book_path(@book.id)
      flash[:notice] = "You have creatad book successfully."
    else
      @user = current_user
      @books = Book.all
     render :index
    end
  end

  def index
    @user = current_user
    @book = Book.new
    @booknew = Book.new
    @books = Book.all
  end

  def show
    @booknew = Book.new
    @book = Book.find(params[:id])
    @user = @book.user

  end

  def edit
    @book = Book.find(params[:id])
  end

  def update
    @book = Book.find(params[:id])
    if @book.update(book_params)
       redirect_to book_path(@book.id)
       flash[:notice]="Book was successfully updated."
    else
    render :edit
    end
  end

  def destroy
    @book = Book.find(params[:id])
    @book.destroy
    redirect_to books_path
  end

private
    def book_params
      params.require(:book).permit(:title, :body)
    end

    def  ensure_current_user
      @book = Book.find(params[:id])
    if @book.user_id != current_user.id
       redirect_to books_path
    end
    end

end

