Asciidoctor::Extensions.register do
  # A block macro that consumes the footnotes from the document catalog and puts them into a dedicated section.
  #
  # Usage
  #
  #   footnotes::[]
  #
  # The footnotes block macro may be added to the language in the future, so you may want to choose another name.
  #
  block_macro :footnotes do
    process do |parent|
      parent << (section = create_section parent, 'References', {})
      section.define_singleton_method :create_list, (method :create_list).to_proc
      section.define_singleton_method :create_list_item, (method :create_list_item).to_proc
      super_content = (section.public_method :content).unbind
      section.define_singleton_method :content do
        self << (list = create_list self, :olist)
        document.catalog[:footnotes].select! do |fn|
          list << (create_list_item list, fn.text)
          false
        end
        super_content.bind_call self
      end
      nil
    end
  end
end
