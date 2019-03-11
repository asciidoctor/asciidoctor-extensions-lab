require 'asciidoctor/extensions' unless RUBY_ENGINE == 'opal'

include Asciidoctor


# toggles whether to generate an <indexterm> for EMPTY/MISSING PRIMARY-positional attribute, in indexing_note/indexing_start
$empty_indexing_primary_allowed = false

# toggles whether to generate EMPTY secondary or tertiary for indexing_note/indexing_start that invokes its 'sortas' attribute
$empty_indexing_elems_allowed = false


class IndexMarkupNoteInlineMacro < Extensions::InlineMacroProcessor
  use_dsl

  named :indexing_note
  name_positional_attributes 'primary', 'secondary', 'tertiary'
  
  using_format :short  # this way, no <target> bit is required (OR EVEN ALLOWED!) in the inline-macro-notation
  
  def process parent, target, attrs
	return unless (parent.document.basebackend? 'docbook') && ($empty_indexing_primary_allowed || ((attrs.has_key? 'primary') && (attrs['primary'])))

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
	    type = attrs[$&]
	  elsif x =~ /^zone$/i
	    zone = attrs[$&]
	  elsif x =~ /^see$/i
	    see_string += "<see>#{attrs[$&]}</see>"
	  elsif x =~ /^seealso[0-9]*$/i
	    see_string += "<seealso>#{attrs[$&]}</seealso>"
	  elsif x =~ /^significance$/i
	    significance = attrs[$&].downcase
	  elsif x =~ /^scope$/i
	    scope = attrs[$&].downcase
	  elsif x =~ /^primary_sortas$/i
	    primary_sortas = attrs[$&]
	  elsif x =~ /^secondary_sortas$/i
	    secondary_sortas = attrs[$&]
	  elsif x =~ /^tertiary_sortas$/i
	    tertiary_sortas = attrs[$&]
	  elsif x =~ /^pagenum$/i
	    pagenum = attrs[$&]
	  end
	end
	
	zony = zone ? %( zone="#{zone}") : nil
	typy = type ? %( type="#{type}") : nil
	pagenumy = pagenum ? %( pagenum="#{pagenum}") : nil
	signy = significance && (sig_arr.include? significance) ? %( significance="#{significance}") : nil
	scopy = scope && (sco_arr.include? scope) ? %( scope="#{scope}") : nil
	sortas_1 = primary_sortas ? %( sortas="#{primary_sortas}") : nil
	sortas_2 = secondary_sortas ? %( sortas="#{secondary_sortas}") : nil
	sortas_3 = tertiary_sortas ? %( sortas="#{tertiary_sortas}") : nil
	secy = sec || (sortas_2 && $empty_indexing_elems_allowed) ? %(<secondary#{sortas_2}>#{sec}</secondary>) : nil
	terty = tert || (sortas_3 && $empty_indexing_elems_allowed) ? %(<tertiary#{sortas_3}>#{tert}</tertiary>) : nil

	# The DocBook schema will complain if you put both <see> and <seealso> in the same <indexterm>. (THIS MACRO WILL LET YOU! :o

	%(<indexterm#{typy}#{zony}#{pagenumy}#{signy}#{scopy}><primary#{sortas_1}>#{attrs['primary']}</primary>#{secy}#{terty}#{see_string}</indexterm>)
  
  end
end

class IndexMarkupRangeStartInlineMacro < Extensions::InlineMacroProcessor
  use_dsl

  named :indexing_start
  name_positional_attributes 'primary', 'secondary', 'tertiary'
  
  using_format :short  # this way, no <target> bit is required (OR EVEN ALLOWED!) in the inline-macro-notation
  
  def process parent, target, attrs
	return unless (parent.document.basebackend? 'docbook') && ($empty_indexing_primary_allowed || ((attrs.has_key? 'primary') && (attrs['primary'])))

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
	    type = attrs[$&]
	  elsif x =~ /^id$/i
	    id = attrs[$&]
	  elsif x =~ /^see$/i
	    see_string += "<see>#{attrs[$&]}</see>"
	  elsif x =~ /^seealso[0-9]*$/i
	    see_string += "<seealso>#{attrs[$&]}</seealso>"
	  elsif x =~ /^significance$/i
	    significance = attrs[$&].downcase
	  elsif x =~ /^scope$/i
	    scope = attrs[$&].downcase
	  elsif x =~ /^primary_sortas$/i
	    primary_sortas = attrs[$&]
	  elsif x =~ /^secondary_sortas$/i
	    secondary_sortas = attrs[$&]
	  elsif x =~ /^tertiary_sortas$/i
	    tertiary_sortas = attrs[$&]
	  elsif x =~ /^pagenum$/i
	    pagenum = attrs[$&]
	  end
	end
	
	idy = (parent.document.backend == 'docbook45') ? %( id="#{id}") : %( xml:id="#{id}")
	typy = type ? %( type="#{type}") : nil
	pagenumy = pagenum ? %( pagenum="#{pagenum}") : nil
	signy = significance && (sig_arr.include? significance) ? %( significance="#{significance}") : nil
	scopy = scope && (sco_arr.include? scope) ? %( scope="#{scope}") : nil
	sortas_1 = primary_sortas ? %( sortas="#{primary_sortas}") : nil
	sortas_2 = secondary_sortas ? %( sortas="#{secondary_sortas}") : nil
	sortas_3 = tertiary_sortas ? %( sortas="#{tertiary_sortas}") : nil
	secy = sec || (sortas_2 && $empty_indexing_elems_allowed) ? %(<secondary#{sortas_2}>#{sec}</secondary>) : nil
	terty = tert || (sortas_3 && $empty_indexing_elems_allowed) ? %(<tertiary#{sortas_3}>#{tert}</tertiary>) : nil

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
	    id = attrs[$&]
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
	    type = attrs[$&]
	    break
	  end
	end
  
	typy = type ? %( type="#{type}") : nil

	dbook = %(<index#{typy}>#{title}</index>)
	create_pass_block parent, dbook, attrs, subs: nil
	
  end
end

