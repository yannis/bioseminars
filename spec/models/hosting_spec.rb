require 'spec_helper'

describe Hosting do
  it {should belong_to :host}
  it {should belong_to :seminar}
  it {should validate_presence_of(:host_id).on(:update)}
  it {should validate_presence_of( :seminar_id).on(:update)}
end
