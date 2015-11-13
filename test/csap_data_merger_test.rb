require 'minitest/autorun'
require 'minitest/pride'
require './lib/csap_data_merger'
require 'pry'

class CSAPDataMergerTest < Minitest::Test
  def test_merges_csap_math_reading_writing
    # math_data = {"COLORADO" => {:all_students => {2011 => {:math => 0.5573}, 2012 => {:math => 0.558}},
    #                 :asian => {2011 => {:math => 0.7094}, 2012 => {:math => 0.7192}}},
    #                 "ACADEMY 20" => {:all_students => {2011 => {:math => 0.68}, 2012 => {:math => 0.6894}},
    #                 :asian => {2011 => {:math => 0.8169}, 2012 => {:math => 0.8182}}}}
    #
    # reading_data = {"COLORADO" => {:all_students => {2011 => {:reading => 0.68}, 2012 => {:reading => 0.6932}},
    #                 :asian => {2011 => {:reading => 0.7482}, 2012 => {:reading => 0.7574}}},
    #                 "ACADEMY 20" => {:all_students => {2011 => {:reading => 0.83}, 2012 => {:reading => 0.84585}},
    #                 :asian => {2011 => {:reading => 0.8976}, 2012 => {:reading => 0.89328}}}}
    #
    # writing_data = {"COLORADO" => {:all_students => {2011 => {:writing => 0.5531}, 2012 => {:writing => 0.5404}},
    #                 :asian => {2011 => {:writing => 0.6569}, 2012 => {:writing => 0.8658}}},
    #                 "ACADEMY 20" => {:all_students => {2011 => {:writing => 0.7192}, 2012 => {:writing => 0.70593}},
    #                 :asian => {2011 => {:writing => 0.8268}, 2012 => {:writing => 0.8083}}}}
    merger = CSAPDataMerger.new({
                                :statewide_testing => {
                                  :math => "./test/fixtures/csap_data/math_data_sample.csv",
                                  :reading => "./test/fixtures/csap_data/reading_data_sample.csv",
                                  :writing => "./test/fixtures/csap_data/writing_data_sample.csv"
                                }
                              })

    expected = [ {:name=>"COLORADO",
                  :csap_data=>
                   {:all_students=>
                     {2011=>{:math=>0.5573, :reading=>0.68, :writing=>0.5531}, 2012=>{:math=>0.558, :reading=>0.6932, :writing=>0.5404}},
                    :asian=>
                     {2011=>{:math=>0.7094, :reading=>0.7482, :writing=>0.6569}, 2012=>{:math=>0.7192, :reading=>0.7574, :writing=>0.6588}}}},
                 {:name=>"ACADEMY 20",
                  :csap_data=>
                   {:all_students=>
                     {2011=>{:math=>0.68, :reading=>0.83, :writing=>0.7192}, 2012=>{:math=>0.6894, :reading=>0.84585, :writing=>0.70593}},
                    :asian=>
                     {2011=>{:math=>0.8169, :reading=>0.8976, :writing=>0.8268}, 2012=>{:math=>0.8182, :reading=>0.89328, :writing=>0.8083}}}}]

    assert_equal expected, merger.merge_csap_data
  end

end
