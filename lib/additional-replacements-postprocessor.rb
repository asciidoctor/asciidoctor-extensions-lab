require 'asciidoctor/extensions' unless RUBY_ENGINE == 'opal'

include Asciidoctor

class AdditionalReplacementsPostprocessor < Extensions::Postprocessor
  MathSymbolPatterns = [/(?<![\\0-9])1\/2(?![0-9])/, /(?<![\\0-9])1\/4(?![0-9])/, /(?<![\\0-9])3\/4(?![0-9])/]
  MathSymbols = ['&#189;', '&#188;', '&#190;']

  MathSymbolPatternsEscaped = [/\\1\/2/, /\\1\/4/, /\\3\/4/]
  MathSymbolsEscaped = ['1/2', '1/4', '3/4']

  AcuteWordPatterns = [/\bSaute/, /\bsaute/, /\bDecor\b/, /\bdecor\b/, /\bCliche/, /\bcliche/, /\bEntree/, /\bentree/, /\bTouche\b/, /\btouche\b/, /\bRisque\b/, /\brisque\b/]
  AcuteWords = ['Saut&#233;', 'saut&#233;', 'D&#233;cor', 'd&#233;cor', 'Clich&#233;', 'clich&#233;', 'Entr&#233;e', 'entr&#233;e', 'Touch&#233;', 'touch&#233;', 'Risqu&#233;', 'risqu&#233;']

  CedillaWordPatterns = [/\bFacade/, /\bfacade/, /\bSoupcon/, /\bsoupcon/]
  CedillaWords = ['Fa&#231;ade', 'fa&#231;ade', 'Soup&#231;on', 'soup&#231;on']

  UmlautWordPatterns = [/\bNaive/, /\bnaive/, /\bNaivite/, /\bnaivite/]
  UmlautWords = ['Na&#239;ve', 'na&#239;ve', 'Na&#239;vit&#233;', 'na&#239;vit&#233;']

  CombinedPatterns = MathSymbolPatterns + MathSymbolPatternsEscaped + AcuteWordPatterns + CedillaWordPatterns + UmlautWordPatterns
  CombinedReplacements = MathSymbols + MathSymbolsEscaped + AcuteWords + CedillaWords + UmlautWords

  def process document, output
    CombinedPatterns.zip(CombinedReplacements).each do |pattern, replacement|
      output = output.gsub pattern, replacement
    end
    output
  end
end

Extensions.register :additionalreplacements do |document|
  document.postprocessor AdditionalReplacementsPostprocessor
end


