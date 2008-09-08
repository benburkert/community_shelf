module DataMapper
  module Is
    module Permalink
      # fired when your plugin gets included into Resource
      def self.included(base)
      end

      ##
      # Methods that should be included in Resource::ClassMethods.
      # Normally this should just be your generator, so that the namespace
      # does not get cluttered. ClassMethods and InstanceMethods gets added
      # in the specific resources when you fire is :example
      def is_permalink(source, dest = :slug, options = {})
        include InstanceMethods
        extend SingletonMethods

        dest, options = :slug, dest if dest.is_a? Hash

        property dest, String, options.merge(:nullable => false, :unique => true)

        before :valid? do
          create_permalink!(source, dest) if new_record?
        end

        # Add class-methods
        extend  DataMapper::Is::Permalink::ClassMethods
        # Add instance-methods
        include DataMapper::Is::Permalink::InstanceMethods
      end

      module ClassMethods
      end # ClassMethods
      
      # Adds class methods.
      module SingletonMethods
        def format_source(s)
          s.gsub(/'/,'').gsub(/[\W]/,' ').strip.gsub(/\ +/,'-').downcase
        end
      end
      
      module InstanceMethods
        
        def create_permalink!(source, ident)
          source_column = source.to_s
          identifier_column = ident.to_s
          if source_value = self.send(source_column).to_s.dup
            parsed_source = self.class.format_source(source_value)[0, 46]
            count = self.class.all(:slug.like => "#{parsed_source}%").count
            parsed_value = (count == 0) ? parsed_source : "#{parsed_source}-#{count + 1}"
            self.send("#{identifier_column}=".to_sym,"#{parsed_value}")
          end
        end

        def to_param
          self.slug
        end
      end # InstanceMethods

    end # Permalink
  end # Is
end # DataMapper