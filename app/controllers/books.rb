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

  class BooksNotFound < NotFound; end
  class BooksNotFound < NotFound; end
end