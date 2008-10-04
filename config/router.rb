Merb.logger.info("Compiling routes...")
Merb::Router.prepare do

  identify(Review => :id) do
    to(:controller => 'reviews') do
      match('/review/:id').to(:action => 'show').name(:review)
      match('/review/new', :method => 'post').to(:action => 'create').name(:new_review)
    end
  end

  identify(Book => :slug) do
    to(:controller => 'books') do
      match('/book/:isbn', :isbn => /^((?:\d{10})|(?:\d{13}))$/).to(:action => 'isbn_lookup')

      match('/books/:id/edit', :method => :get).to(:action => 'edit').name(:edit_book)

      match('/books/new', :method => 'post').to(:action => 'create')
      match('/books/new').to(:action => 'new').name(:new_book)

      match('/books/:id/checkin', :method => :post).to(:action => 'checkin').name(:checkin)
      match('/books/:id/checkout', :method => :post).to(:action => 'checkout').name(:checkout)

      match('/book/:id').to(:action => 'show').name(:book)
      match('/books/(:term)').to(:action => 'index').name(:books)
    end
  end

  to(:controller => 'users') do
    match('/signup', :method => :post).to(:action => 'create')
    match('/signup').to(:action => 'new').name(:signup)
  end

  to(:controller => 'sessions') do
    match('/login/complete').to(:action => 'create').name(:complete_login)
    match('/login', :method => :post).to(:action => 'create')
    match('/login').to(:action => 'new').name(:login)
    match('/logout').to(:action => 'destroy').name(:logout)
  end

  match('/').to(:controller => 'dash', :action => 'index').name(:dash)
end