class Reviews < Application
  before :ensure_authenticated

  #eager_cache(:create, [Dash, :index], :store => :action_store) { build_request(build_url(:dash)) }

  def create(review)
    book = Book.first(:slug => review[:book]) || raise(BookNotFound, review[:book])

    @review = Review.new(review.merge(:book => book, :user => session.user))
    if @review.save
      redirect(url(:book, book, :review => @review), :message => "Your review of \"#{book.short_title}\" has been added")
    else
      redirect(url(:book, book), :message => "Your review of \"#{book.short_title}\" has encountered an error: #{book.errors}")
    end
  end

end
