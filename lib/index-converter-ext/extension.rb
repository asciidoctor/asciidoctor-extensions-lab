require 'asciidoctor/converter/html5'

module Asciidoctor
  class IndexCatalog
    LeadingAlphaRx = /^[[:alpha:]]/

    def initialize
      @categories = {}
    end
  
    def store_term names, id
      if (num_terms = names.size) > 2
        store_tertiary_term names[0], names[1], names[2], id
      elsif num_terms == 2
        store_secondary_term names[0], names[1], id
      elsif num_terms == 1
        store_primary_term names[0], id
      end
    end
  
    def store_primary_term name, id = nil
      (init_category name.chr.upcase).store_term name, id
    end
  
    def store_secondary_term primary_name, secondary_name, id = nil
      (store_primary_term primary_name).store_term secondary_name, id
    end
  
    def store_tertiary_term primary_name, secondary_name, tertiary_name, id
      (store_secondary_term primary_name, secondary_name).store_term tertiary_name, id
    end
  
    def init_category name
      name = '@' unless LeadingAlphaRx =~ name
      @categories[name] ||= (IndexTermCategory.new name)
    end
  
    def find_category name
      @categories[name]
    end

    def empty?
      @categories.empty?
    end

    def categories
      @categories.empty? ? [] : @categories.values.sort
    end
  end
  
  class IndexTermGroup
    include Comparable
    attr_reader :name
  
    def initialize name
      @name = name 
      @terms = {}
    end
  
    def store_term name, id
      (@terms[name] ||= (IndexTerm.new name)).append_dest id
    end
  
    def find_term name
      @terms[name]
    end
  
    def terms
      @terms.empty? ? [] : @terms.values.sort
    end

    def <=> other
      @name <=> other.name
    end
  end
  
  class IndexTermCategory < IndexTermGroup; end
  
  class IndexTerm < IndexTermGroup
    def initialize name
      super
      @dests = ::Set.new
    end
  
    alias subterms terms
  
    def append_dest dest
      @dests << dest
      self
    end
  
    def dests
      @dests
    end

    def primary_dest
      @dests.first
    end
  
    def container?
      @dests.empty?
    end
  
    def leaf?
      @terms.empty?
    end
  end

  module Converter
    module Html5ConverterExt
      def document node
        @index = node.catalog[:index] = IndexCatalog.new
        @idprefix = node.attributes['idprefix'] || '_'
        @idseparator = node.attributes['idseparator'] || '_'
        super
      end

      def section node
        if node.level == 1 && node.sectname == 'index'
          unless @index.empty?
            index node
            super
          end
        else
          super
        end
      end

      def inline_indexterm node
        id = %(#{@idprefix}indexterm#{@idseparator}#{node.object_id})
        if node.type == :visible
          visible_term = node.text
          @index.store_primary_term visible_term, id
        else
          visible_term = ''
          @index.store_term((node.attr 'terms'), id)
        end
        %(<a id="#{id}"></a>#{visible_term})
      end

      def index node
        lines = []
        @index.categories.each do |category|
          lines << %(<h3>#{category.name}</h3>)
          category.terms.each {|term| convert_index_list_item lines, term }
        end
        node.blocks << (Block.new node, :pass, content_model: :raw, subs: [], source: lines)
        nil
      end

      def convert_index_list_item lines, term
        lines << '<dl>'
        if term.container?
          text = term.name
        else
          text = %(<a class="indexterm" href="##{term.primary_dest}">#{term.name}</a>)
        end
        lines << %(<dt style="font-weight: normal">#{text}</dt>)
        unless term.leaf?
          lines << '<dd>'
          term.subterms.each {|subterm| convert_index_list_item lines, subterm }
          lines << '</dd>'
        end
        lines << '</dl>'
      end
    end
    Html5Converter.prepend Html5ConverterExt
  end
end
