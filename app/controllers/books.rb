class Books < Application
  before :ensure_authenticated, :only => :edit

  def index(q, page, per_page = 20)
    @q = q
    @books, @pagination_info = Book.by_catalog(q).paginate(page, per_page)

    raise BooksNotFound, q if @pagination_info[:count] == 0

    display @books
  end

  def show(id)
    @book = Book.first(:slug => id) || raise(BookNotFound, id)

    display @book
  end

  def new
    @book = Book.new

    display @book
  end

  def edit(id)
    @book = Book.first(:slug => id) || raise(BookNotFound, id)

    display @book
  end

  def isbn_lookup(isbn)
    isbn = ISBN_Tools.isbn10_to_isbn13(isbn) if isbn.size == 10

    @book = Book.first(:isbn => isbn) || raise(IsbnNotFound, isbn)

    redirect url(:book, @book)
  end

  def checkout(id)
    @book = Book.first(:slug => id) || (raise BookNotFound, id)

    if session.user.checkout(@book)
      redirect(url(:book, @book), :message => "You have successfully checked out \"#{@book.short_title}\"")
    else
      redirect(url(:book, :@book), :message => "Sorry, you cannot checkout #{@book.short_title}")
    end
  end

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