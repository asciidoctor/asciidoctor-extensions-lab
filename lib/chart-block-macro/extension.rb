require 'asciidoctor'
require 'asciidoctor/extensions'
require 'csv'

include ::Asciidoctor

# A block macro that embeds a Chart into the output document
#
# Usage
#
#   chart::line[data-uri=sample.csv]
#
class ChartBlockMacro < Extensions::BlockMacroProcessor
  use_dsl

  named :chart

  def process parent, target, attrs
    data = CSV.read(File.join parent.document.base_dir, attrs['data-uri'])
    labels = data[0]
    data.shift
    defaultColors = [{r:220,g:220,b:220}, {r:151,g:187,b:205}]
    datasets = data.map do |set|
      color = defaultColors[data.index(set) % 2]
      colorRGBA = "rgba(#{color[:r]},#{color[:g]},#{color[:b]},1.0)"
      %(
{
  fillColor: "#{colorRGBA.gsub('1.0', '0.2')}",
  strokeColor: "#{colorRGBA}",
  pointColor: "#{colorRGBA}",
  pointHighlightStroke: "#{colorRGBA}",
  pointStrokeColor: "#fff",
  pointHighlightFill: "#fff",
  data: #{set.to_s}
}
      )
    end.join(",")
    # TODO Replace with CDN when the 1.0 version will be available 
    chartjsScript = %(<script src="#{File.join File.dirname(__FILE__), 'Chart.js'}"></script>)
    # TODO Generate unique id (or read from attributes)
    chartId = "chart1"
    # TODO Read with percent from attributes
    chartWidthPercent = 50
    chartCanvas = %(<div style="width:#{chartWidthPercent}%"><canvas id="#{chartId}"></canvas></div>)
    chartInitCtxScript = %(var ctx = document.getElementById("#{chartId}").getContext("2d");)
    chartInitDataScript = %(var data = {
  labels: #{labels.to_s},
  datasets: [
    #{datasets}
  ]
};)
    chartInitScript = %(var chart = new Chart(ctx).Line(data, {responsive : true});)
    html = %(
#{chartjsScript}
#{chartCanvas}<script type="text/javascript">window.onload = function() {
  #{chartInitCtxScript}
  #{chartInitDataScript}
  #{chartInitScript}
}
</script>)

    create_pass_block parent, html, attrs, subs: nil
  end
end
