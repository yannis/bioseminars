require 'spec_helper'

describe Categorisation do
  it {should belong_to :category}
  it {should belong_to :seminar}
  # it {should validate_presence_of :category_id}
  # it {should validate_presence_of :seminar_id}
end
