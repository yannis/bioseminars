require 'test_helper'

class CategoryTest < ActiveSupport::TestCase
  fixtures :all

  should_have_many :seminars, :dependent => :nullify

  should_validate_presence_of :name, :message => "can't be blank. Please give this category a name."
  should_validate_uniqueness_of :name, :message => "must be unique and this one has already been taken. Please chose another one."
  # should_validate_uniqueness_of :acronym, :message => "must be unique and this one has already been taken. Please chose another one."
  
  context "A category" do
    setup do
      @category = Factory.create(:category, :name => 'cat_name_1', :acronym => nil)
    end
    
    should 'be valid' do
      assert @category.valid?, @category.errors.full_messages.to_sentence
    end
    
    should "have 'cat_name_1' as acronym_or_name" do
      assert_equal @category.acronym_or_name, 'cat_name_1'
    end
  end
end
