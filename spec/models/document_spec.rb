require 'spec_helper'

describe Document do
  it { should have_attached_file :data}
  it { should respond_to :data}
  it { should belong_to :documentable }
  it { should validate_attachment_size :data }
  it { should validate_attachment_content_type :data }
  it { should validate_attachment_size :data }
end

describe "A document" do
  let(:document) { create :document }
  it {expect(document).to be_valid_verbose}
end
