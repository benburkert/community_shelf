Merb.logger.info("Compiling routes...")
Merb::Router.prepare do

  with(:controller => 'reviews') do
    match('/review/new', :method => 'post').to(:action => 'create').name(:new_review)
  end

  identify(Book => :slug, Review => :id) do
    with(:controller => 'books') do
      match('/book/:isbn', :isbn => /^((?:\d{10})|(?:\d{13}))$/).to(:action => 'isbn_lookup')

      match('/books/:id/edit', :method => :put).to(:action => 'update')
      match('/books/:id/edit').to(:action => 'edit').name(:edit_book)

      match('/book/new', :method => 'post').to(:action => 'create')
      match('/book/new').to(:action => 'new').name(:new_book)

      match('/book/:id/checkin', :method => :post).to(:action => 'checkin').name(:checkin)
      match('/book/:id/checkout', :method => :post).to(:action => 'checkout').name(:checkout)

      match('/book/:id(#review-:review)').to(:action => 'show').name(:book)
      match('/books(/:q)').default(:q => 'a').to(:action => 'index').name(:books)
    end
  end

  with(:controller => 'users') do
    match('/signup', :method => :post).to(:action => 'create')
    match('/signup').to(:action => 'new').name(:signup)
  end

  with(:controller => 'sessions') do
    match('/login').to(:action => 'create').name(:openid)
    match('/logout').to(:action => 'destroy').name(:logout)
  end

  match('/').to(:controller => 'dash', :action => 'index').name(:dash)
end