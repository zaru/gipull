module Gipull
  class Formatter

    def initialize(data)
      @data = data
      @sizes = column_size
    end

    def render
      output = ""
      @data.each do |r|
        r.each_with_index do |v,i|
          output += "%-#{@sizes[i] + 2}s" % v.to_s
        end
        output += "\n"
      end
      output
    end

    private

    def column_size
      sizes = Array.new(@data.size, 0)
      @data.each do |r|
        r.each_with_index do |v,i|
          size = v.to_s.size
          sizes[i] = size if sizes[i] < size
        end
      end
      sizes
    end
  end
end