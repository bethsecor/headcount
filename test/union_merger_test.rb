require 'minitest/autorun'
require 'minitest/pride'
require './lib/union_merger'

class UnionMergerTest < Minitest::Test

  def test_merge_hashes_by_district_name
    union_merger = UnionMerger.new
    kinder_data = [{:name => "COLORADO", :kindergarten_participation => { 2006 => 0.33677, 2007 => 0.39465 }},
                   {:name => "ACADEMY 20",:kindergarten_participation => { 2006 => nil, 2007 => 0.39159 }}]
    hs_data =     [{:name => "ACADEMY 20", :high_school_graduation => { 2010 => 0.895, 2011 => 0.895 }},
                   {:name => "ADAMS COUNTY 14",:high_school_graduation => { 2010 => 0.57, 2011 => 0.608 }},
                   {:name => "ADAMS-ARAPAHOE 28J", :high_school_graduation => { 2010 => 0.455, 2011 => 0.485 }}]

    expected =    [{:name => "COLORADO", :kindergarten_participation => { 2006 => 0.33677, 2007 => 0.39465 }},
                   {:name => "ACADEMY 20",:kindergarten_participation => { 2006 => nil, 2007 => 0.39159 },
                                          :high_school_graduation => { 2010 => 0.895, 2011 => 0.895 }},
                   {:name => "ADAMS COUNTY 14",:high_school_graduation => { 2010 => 0.57, 2011 => 0.608 }},
                   {:name => "ADAMS-ARAPAHOE 28J", :high_school_graduation => { 2010 => 0.455, 2011 => 0.485 }}]
    assert_equal expected, union_merger.merge(kinder_data, hs_data)
  end

  def test_left_join_hashes_by_district_name
    union_merger = UnionMerger.new
    kinder_data = [{:name => "COLORADO", :kindergarten_participation => { 2006 => 0.33677, 2007 => 0.39465 }},
                   {:name => "ACADEMY 20",:kindergarten_participation => { 2006 => nil, 2007 => 0.39159 }}]
    hs_data =     [{:name => "ACADEMY 20", :high_school_graduation => { 2010 => 0.895, 2011 => 0.895 }},
                   {:name => "ADAMS COUNTY 14",:high_school_graduation => { 2010 => 0.57, 2011 => 0.608 }},
                   {:name => "ADAMS-ARAPAHOE 28J", :high_school_graduation => { 2010 => 0.455, 2011 => 0.485 }}]

    expected =    [{:name => "COLORADO", :kindergarten_participation => { 2006 => 0.33677, 2007 => 0.39465 }},
                   {:name => "ACADEMY 20",:kindergarten_participation => { 2006 => nil, 2007 => 0.39159 },
                                          :high_school_graduation => { 2010 => 0.895, 2011 => 0.895 }}]
    assert_equal expected, union_merger.join(kinder_data, hs_data)
  end

  def test_right_join_hashes_by_district_name
    union_merger = UnionMerger.new
    kinder_data = [{:name => "COLORADO", :kindergarten_participation => { 2006 => 0.33677, 2007 => 0.39465 }},
                   {:name => "ACADEMY 20",:kindergarten_participation => { 2006 => nil, 2007 => 0.39159 }}]
    hs_data =     [{:name => "ACADEMY 20", :high_school_graduation => { 2010 => 0.895, 2011 => 0.895 }},
                   {:name => "ADAMS COUNTY 14",:high_school_graduation => { 2010 => 0.57, 2011 => 0.608 }},
                   {:name => "ADAMS-ARAPAHOE 28J", :high_school_graduation => { 2010 => 0.455, 2011 => 0.485 }}]

    expected =    [{:name => "ACADEMY 20",:kindergarten_participation => { 2006 => nil, 2007 => 0.39159 },
                                          :high_school_graduation => { 2010 => 0.895, 2011 => 0.895 }},
                   {:name => "ADAMS COUNTY 14",:high_school_graduation => { 2010 => 0.57, 2011 => 0.608 }},
                   {:name => "ADAMS-ARAPAHOE 28J", :high_school_graduation => { 2010 => 0.455, 2011 => 0.485 }}]
    assert_equal expected, union_merger.join(hs_data, kinder_data)
  end

end
