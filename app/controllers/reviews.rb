class Reviews < Application
  before :ensure_authenticated

  def create(review)
    debugger
    book = Book.first(:slug => review[:book]) || raise(BookNotFound, review[:book])

    @review = Review.new(review.merge(:book => book, :user => session.user))
    if @review.save
      redirect(url(:book, book, :review => @review), :message => "Your review of \"#{book.short_title}\" has been added")
    else
      redirect(url(:book, book), :message => "Your review of \"#{book.short_title}\" has encountered an error: #{book.errors}")
    end
  end

end
