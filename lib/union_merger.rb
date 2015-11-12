# Merges two arrays of hashes
class UnionMerger
  def merge(data_1, data_2)
    left = join(data_1, data_2)
    right = join(data_2, data_1)
    combine_join(left, right)
  end

  def join(data_1, data_2)
    data_1.map do |hash_1|
      match = data_2.find { |hash_2| hash_1[:name] == hash_2[:name] }
      if match.nil?
        hash_1
      else
        hash_1.merge(match)
      end
    end
  end

  def combine_join(left, right)
    (left + right).uniq
  end
end
