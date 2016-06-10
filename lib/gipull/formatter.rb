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
          # output += "%-#{@sizes[i] + 2}s" % v.to_s
          output += pad_to_print_size(v.to_s, @sizes[i] + 2)
        end
        output += "\n"
      end
      output
    end

    private

    def pad_to_print_size(string, size)
      padding_size = size - print_size(string)
      padding_size = 0 if size < 0
      string + ' ' * padding_size
    end

    def print_size(string)
      string.each_char.map{|c| c.bytesize == 1 ? 1 : 2}.reduce(0, &:+)
    end

    def column_size
      sizes = Array.new(@data[0].size, 0)
      @data.each do |r|
        r.each_with_index do |v,i|
          size = print_size(v)
          sizes[i] = size if sizes[i] < size
        end
      end
      sizes
    end
  end
end