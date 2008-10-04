class Books < Application

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

  def isbn_lookup(isbn)
    isbn = ISBN_Tools.isbn10_to_isbn13(isbn) if isbn.size == 10

    @book = Book.first(:isbn => isbn) || raise(IsbnNotFound, isbn)

    redirect url(:book, @book)
  end

  class BookNotFound < NotFound; end
  class BooksNotFound < NotFound; end
end