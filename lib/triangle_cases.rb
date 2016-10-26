class TriangleCase < OpenStruct
  def name
    initial = description.downcase
    replaced = initial.gsub(/(true|false)/, replacements)
    if initial.eql?(replaced) && !initial.include?(triangle)
      replaced = triangle + ' triangle ' + initial
    end
    'test_%s' % replaced.gsub(/[ ,-]/, '_')
  end

  def replacements
    booleans = { 'true' => '', 'false' => ' not' }
    booleans.each { |k, v| booleans[k] = "triangle is#{v} #{triangle}" }
  end

  def do
    "triangle.#{triangle}?"
  end

  def skipped?
    index > 0
  end

  def failure_message
    "Expected '#{expected}', triangle is #{expected ? '' : 'not '}#{triangle}."
  end
end

TriangleCases = proc do |data|
  i = 0
  cases = []
  data = JSON.parse(data).select { |key, value| key.to_s.match(/[^#]+/) }
  data.keys.each do |triangle|
    data[triangle]['cases'].each do |row|
      row = row.merge(row.merge('index' => i, 'triangle' => triangle))
      cases << TriangleCase.new(row)
      i += 1
    end
  end
  cases
end
