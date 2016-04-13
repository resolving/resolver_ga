module ResolverSeo
  class Ncile

    attr_accessor :n, :array

    def initialize(array, n)
      self.n = n
      self.array = array
    end

    def segment_length
      array.length.to_f / n.to_f 
    end

    def segment_start(i)
      (i - 1).to_f * segment_length.to_f
    end

    def segment(i)
      array.slice(segment_start(i)..(segment_start(i) + segment_length - 1))
    end

    def ncile_with_index
      (1..n).collect do |i|
        if block_given?
          {index: i, data: yield(segment(i), i)}
        else
          {index: i, data: segment(i)}
        end
      end
    end

    def median
      if array.empty?
        0
      elsif array.length.even?
        lower_index = (array.length / 2) - 1
        upper_index = lower_index + 1
        (array.fetch(lower_index) + array.fetch(upper_index)) / 2.0
      else
        array.fetch((array.length / 2.0).floor)
      end
    end

  end
end
