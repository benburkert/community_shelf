class ISBNDB

  def self.fetch_by_isbn(*args)
    ISBNDB.new(Merb::Config[:isbndb_key]).fetch_by_isbn(*args)
  end
  
  def initialize(api_key)
    @api_key = api_key
  end

  def fetch_book(params)
    Curl::Easy.perform("http://isbndb.com/api/books.xml?#{get_params(params)}").body_str.to_libxml_doc
  end

  def get_params(params = {})
    params.merge(:access_key => @api_key).map {|k,v| "#{k}=#{v}"} * '&'
  end

  def isbns(isbn)
    case isbn.size
    when 10
      return isbn, ISBN_Tools.isbn10_to_isbn13(isbn)
    when 13
      return ISBN_Tools.isbn13_to_isbn10(isbn), isbn
    else raise InvalidISBN.new(isbn)
    end
  end

  def fetch_by_isbn(isbn)
    isbn10, isbn13 = *isbns(isbn)
    doc = fetch_book(:index1 => :isbn, :value1 => isbn, :results => :subjects)
    root = doc.root

    node = root.at("BookList/BookData")

    raise BookNotFound, isbn.to_s if node.nil?

    data = case node.attributes[:isbn]
      when isbn10, isbn13 then {:isbn => isbn}
      else raise BookNotFound.new(:isbn => isbn)
      end
    
    node.children.each do |child_node|
      case child_node.name.to_sym
      when :Title         then data[:short_title] = CGI.unescapeHTML(child_node.inner_xml)
      when :TitleLong     then data[:long_title]  = CGI.unescapeHTML(child_node.inner_xml)
      when :AuthorsText   then data[:author]      = CGI.unescapeHTML(child_node.inner_xml)
      when :PublisherText then data[:publisher]   = CGI.unescapeHTML(child_node.inner_xml)
      end
    end

    data
  end

  class InvalidISBN < Exception; end
  class BookNotFound < Exception; end
end