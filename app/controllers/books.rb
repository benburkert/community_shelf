class Books < Application
  before :ensure_authenticated, :only => [:new, :edit, :update, :checkout, :checkin]

  #cache :index

  def index(q, page = 1, per_page = 20)
    @q = q
    @books, @pagination_info = Book.by_catalog(q).paginate(page, per_page)

    display @books
  end

  def show(id)
    @book = Book.first(:slug => id) || raise(BookNotFound, id)
    @review = Review.new

    display @book
  end

  def new
    @book = Book.new

    display @book
  end

  #eager_cache(:create, [Dash, :index], :store => :action_store) { build_request(build_url(:dash)) }

  def create(book, submit)
    case submit.to_sym
    when :lookup
      @book = Book.new(ISBNDB.fetch_by_isbn(book[:isbn].gsub(/[^0-9]*/, "")))

      display @book, "books/new"
    when :create
      @book = Book.new(book.merge(:owner => session.user))

      if @book.save
        redirect(url(:new_book), :message => "\"#{@book.short_title}\" has been added")
      else
        display @book, "books/new"
      end
    end    
  end

  def edit(id)
    @book = Book.first(:slug => id) || raise(BookNotFound, id)

    display @book
  end

  #eager_cache(:update, [Dash, :index], :store => :action_store) { build_request(build_url(:dash)) }

  def update(id, book)
    @book = Book.first(:slug => id) || raise(BookNotFound, id)

    @book.update_attributes(book)

    if @book.valid?
      redirect(url(:book, @book), :message => "\"#{@book.short_title}\" has been updated")
    else
      display @book, 'books/edit'
    end
  end

  def isbn_lookup(isbn)
    isbn = ISBN_Tools.isbn10_to_isbn13(isbn) if isbn.size == 10

    @book = Book.first(:isbn => isbn) || raise(IsbnNotFound, isbn)

    redirect url(:book, @book)
  end

  #eager_cache(:checkout, [Dash, :index], :store => :action_store) { build_request(build_url(:dash)) }

  def checkout(id)
    @book = Book.first(:slug => id) || (raise BookNotFound, id)

    if session.user.checkout(@book)
      redirect(url(:book, @book), :message => "You have successfully checked out \"#{@book.short_title}\"")
    else
      redirect(url(:book, @book), :message => "Sorry, you cannot checkout #{@book.short_title}")
    end
  end

  #eager_cache(:checkin, [Dash, :index], :store => :action_store) { build_request(build_url(:dash)) }

  def checkin(id)
    @book = Book.first(:slug => id) || (raise BookNotFound, id)

    if reservation = session.user.reservations.checked_out.for(@book).first
      if reservation.checkin
        redirect(url(:book, id), :message => "You have successfully returned \"#{@book.short_title}\"")
      else
        redirect(url(:book, id), :message => "Sorry, you were not able to check in \"#{@book.short_title}\"")
      end
    else
      redirect(url(:book, id), :message => "Sorry, there is no record of you checking out \"#{@book.short_title}\"")
    end
  end

  class BookNotFound < NotFound; end
  class BooksNotFound < NotFound; end
end