require 'asciidoctor/extensions' unless RUBY_ENGINE == 'opal'

include Asciidoctor

class IndexMarkupNoteInlineMacro < Extensions::InlineMacroProcessor
  use_dsl

  named :indexing_note
  name_positional_attributes 'primary', 'secondary', 'tertiary'
  
  using_format :short  # this way, no <target> bit is required (OR EVEN ALLOWED!) in the inline-macro-notation
  
  def process parent, target, attrs
	return unless (parent.document.basebackend? 'docbook')

    # some positional attributes:
    sec = (attrs.has_key? 'secondary') ? attrs['secondary'] : nil
	tert = (attrs.has_key? 'tertiary') ? attrs['tertiary'] : nil
	
	# some named attributes:
	type = nil
	zone = nil
	pagenum = nil
	significance = nil
	scope = nil
	primary_sortas = nil
	secondary_sortas = nil
	tertiary_sortas = nil

	sig_arr = [ 'normal', 'preferred' ]
	sco_arr = [ 'global', 'local', 'all' ]
	see_string = ''
	
	attrs.each_key do |x|
	  if x =~ /^type$/i
		type = "#{attrs[$&]}"
	  elsif x =~ /^zone$/i
		zone = "#{attrs[$&]}"
	  elsif x =~ /^see$/i
	    see_string += "<see>#{attrs[$&]}</see>"
	  elsif x =~ /^seealso[0-9]*$/i
	    see_string += "<seealso>#{attrs[$&]}</seealso>"
	  elsif x =~ /^significance$/i
		significance = "#{attrs[$&]}".downcase
	  elsif x =~ /^scope$/i
		scope = "#{attrs[$&]}".downcase
	  elsif x =~ /^primary_sortas$/i
		primary_sortas = "#{attrs[$&]}"
	  elsif x =~ /^secondary_sortas$/i
		secondary_sortas = "#{attrs[$&]}"
	  elsif x =~ /^tertiary_sortas$/i
		tertiary_sortas = "#{attrs[$&]}"
	  elsif x =~ /^pagenum$/i
		pagenum = "#{attrs[$&]}"
	  end
	end
	
	zony = zone ? %( zone="#{zone}") : nil
	typy = type ? %( type="#{type}") : nil
	pagenumy = pagenum ? %( pagenum="#{pagenum}") : nil
    signy = significance && (sig_arr.include? significance) ? %( significance="#{significance}") : nil
    scopy = scope && (sco_arr.include? scope) ? %( scope="#{scope}") : nil
	sortas_1 = primary_sortas && (attrs.has_key? 'primary') ? %( sortas="#{primary_sortas}") : nil
	sortas_2 = secondary_sortas ? %( sortas="#{secondary_sortas}") : nil
	sortas_3 = tertiary_sortas ? %( sortas="#{tertiary_sortas}") : nil
	secy = sec ? %(<secondary#{sortas_2}>#{sec}</secondary>) : nil
	terty = tert ? %(<tertiary#{sortas_3}>#{tert}</tertiary>) : nil

	# The DocBook schema will complain if you put both <see> and <seealso> in the same <indexterm>. (THIS MACRO WILL LET YOU! :o

	# @zone is of type IDREFS, so holds a single-whitespace- (i.e., #x20)-separated list; "so a single IndexTerm can point to multiple ranges."
	# But then, if you're going to use @zone, NONE OF the block-ids' names you're referencing may contain ANY SPACES!!
	# Asciidoctor's auto-generated IDs are OK!! but, if defining your own anchors (User Manual sec. 27.2), please note the rules that Asciidoctor uses when generating such (sec. 16.2; https://asciidoctor.org/docs/user-manual/#auto-generated-ids )

    %(<indexterm#{typy}#{zony}#{pagenumy}#{signy}#{scopy}><primary#{sortas_1}>#{attrs['primary']}</primary>#{secy}#{terty}#{see_string}</indexterm>)
  
  end
end

class IndexMarkupRangeStartInlineMacro < Extensions::InlineMacroProcessor
  use_dsl

  named :indexing_start
  name_positional_attributes 'primary', 'secondary', 'tertiary'
  
  using_format :short  # this way, no <target> bit is required (OR EVEN ALLOWED!) in the inline-macro-notation
  
  def process parent, target, attrs
	return unless (parent.document.basebackend? 'docbook')

    # some positional attributes:
    sec = (attrs.has_key? 'secondary') ? attrs['secondary'] : nil
	tert = (attrs.has_key? 'tertiary') ? attrs['tertiary'] : nil
	
	# some named attributes:
	type = nil
	id = 'phonyID_you-were-missing-a-real-one'
	pagenum = nil
	significance = nil
	scope = nil
	primary_sortas = nil
	secondary_sortas = nil
	tertiary_sortas = nil
	
	sig_arr = [ 'normal', 'preferred' ]
	sco_arr = [ 'global', 'local', 'all' ]
	see_string = ''
	
	attrs.each_key do |x|
	  if x =~ /^type$/i
		type = "#{attrs[$&]}"
	  elsif x =~ /^id$/i
	    id = "#{attrs[$&]}"
	  elsif x =~ /^see$/i
	    see_string += "<see>#{attrs[$&]}</see>"
	  elsif x =~ /^seealso[0-9]*$/i
	    see_string += "<seealso>#{attrs[$&]}</seealso>"
	  elsif x =~ /^significance$/i
		significance = "#{attrs[$&]}".downcase
	  elsif x =~ /^scope$/i
		scope = "#{attrs[$&]}".downcase
	  elsif x =~ /^primary_sortas$/i
		primary_sortas = "#{attrs[$&]}"
	  elsif x =~ /^secondary_sortas$/i
		secondary_sortas = "#{attrs[$&]}"
	  elsif x =~ /^tertiary_sortas$/i
		tertiary_sortas = "#{attrs[$&]}"
	  elsif x =~ /^pagenum$/i
		pagenum = "#{attrs[$&]}"
	  end
	end
	
	idy = %( id="#{id}")
	typy = type ? %( type="#{type}") : nil
	pagenumy = pagenum ? %( pagenum="#{pagenum}") : nil
    signy = significance && (sig_arr.include? significance) ? %( significance="#{significance}") : nil
    scopy = scope && (sco_arr.include? scope) ? %( scope="#{scope}") : nil
	sortas_1 = primary_sortas && (attrs.has_key? 'primary') ? %( sortas="#{primary_sortas}") : nil
	sortas_2 = secondary_sortas ? %( sortas="#{secondary_sortas}") : nil
	sortas_3 = tertiary_sortas ? %( sortas="#{tertiary_sortas}") : nil
	secy = sec ? %(<secondary#{sortas_2}>#{sec}</secondary>) : nil
	terty = tert ? %(<tertiary#{sortas_3}>#{tert}</tertiary>) : nil

    %(<indexterm#{idy} class="startofrange"#{typy}#{pagenumy}#{signy}#{scopy}><primary#{sortas_1}>#{attrs['primary']}</primary>#{secy}#{terty}#{see_string}</indexterm>)
  
  end
end

class IndexMarkupRangeEndInlineMacro < Extensions::InlineMacroProcessor
  use_dsl

  named :indexing_end
  
  using_format :short  # this way, no <target> bit is required (OR EVEN ALLOWED!) in the inline-macro-notation
  
  def process parent, target, attrs
	return unless (parent.document.basebackend? 'docbook')

    # named attribute:
	id = 'phonyID_you-were-missing-a-real-one'
	
	attrs.each_key do |x|
	  if x =~ /^id$/i
	    id = "#{attrs[$&]}"
		break
	  end
	end	
	
	idy = %( startref="#{id}")

    %(<indexterm#{idy} class="endofrange" />)
  
  end
end


class IndexCatalogBlockMacro < Asciidoctor::Extensions::BlockMacroProcessor
  use_dsl

  named :indexcatalog
  name_positional_attributes 'title'
  
  def process parent, target, attrs
	return unless (parent.document.basebackend? 'docbook')

    # positional attribute:
    ti = (attrs.has_key? 'title') ? attrs['title'] : nil
	title = ti ? %(<title>#{ti}</title>) : nil

	# named attribute:
	type = nil
	
	attrs.each_key do |x|
	  if x =~ /^type$/i
		type = "#{attrs[$&]}"
		break
	  end
	end
  
	typy = type ? %( type="#{type}") : nil

    dbook = %(<index#{typy}>#{title}</index>)
	create_pass_block parent, dbook, attrs, subs: nil
	
  end
end

