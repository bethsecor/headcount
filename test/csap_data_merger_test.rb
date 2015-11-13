require 'minitest/autorun'
require 'minitest/pride'
require './lib/csap_data_merger'
require 'pry'

class CSAPDataMergerTest < Minitest::Test
  def test_merges_csap_math_reading_writing
    math_data = {"COLORADO" => {:all_students => {2011 => {:math => 0.5573}, 2012 => {:math => 0.558}},
                    :asian => {2011 => {:math => 0.7094}, 2012 => {:math => 0.7192}}},
                    "ACADEMY 20" => {:all_students => {2011 => {:math => 0.5737}, 2012 => {:math => 0.0191}},
                    :asian => {2011 => {:math => 0.48281}, 2012 => {:math => 0.10384}}}}

    reading_data = {"COLORADO" => {:all_students => {2011 => {:reading => 0.4882}, 2012 => {:reading => 0.558}},
                    :asian => {2011 => {:reading => 0.383}, 2012 => {:reading => 0.481}}},
                    "ACADEMY 20" => {:all_students => {2011 => {:reading => 0.5737}, 2012 => {:reading => 0.0110}},
                    :asian => {2011 => {:reading => 0.8381}, 2012 => {:reading => 0.3881}}}}

    writing_data = {"COLORADO" => {:all_students => {2011 => {:writing => 0.3828}, 2012 => {:writing => 0.9484}},
                    :asian => {2011 => {:writing => 0.2838}, 2012 => {:writing => 0.85583}}},
                    "ACADEMY 20" => {:all_students => {2011 => {:writing => 0.848484}, 2012 => {:writing => 0.83881}},
                    :asian => {2011 => {:writing => 0.84882}, 2012 => {:writing => 0.8282}}}}

    expected = [ {:name=>"COLORADO",
                  :csap_data=>
                   {:all_students=>
                     {2011=>{:math=>0.5573, :reading=>0.4882, :writing=>0.3828}, 2012=>{:math=>0.558, :reading=>0.558, :writing=>0.9484}},
                    :asian=>
                     {2011=>{:math=>0.7094, :reading=>0.383, :writing=>0.2838}, 2012=>{:math=>0.7192, :reading=>0.481, :writing=>0.85583}}}},
                 {:name=>"ACADEMY 20",
                  :csap_data=>
                   {:all_students=>
                     {2011=>{:math=>0.5737, :reading=>0.5737, :writing=>0.848484}, 2012=>{:math=>0.0191, :reading=>0.011, :writing=>0.83881}},
                    :asian=>
                     {2011=>{:math=>0.48281, :reading=>0.8381, :writing=>0.84882}, 2012=>{:math=>0.10384, :reading=>0.3881, :writing=>0.8282}}}}]
  end

end
