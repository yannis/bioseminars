require File.dirname(__FILE__) + '/../test_helper'

class AbilityTest < ActiveSupport::TestCase

  context "A basic user," do
    setup do
      @user = Factory :user
      @ability = Ability.new(@user)
    end
    
    should "be able to create her own seminars" do
      assert @ability.can?(:create, Seminar)
    end
    
    should "be able to edit her own seminars" do
      assert @ability.can?(:update, Factory(:seminar, :user => @user))
    end
    
    should "be unable to edit seminars from someone else" do
      assert !@ability.can?(:update, Factory(:seminar, :user => Factory(:user)))
    end
    
    should "be able to destroy her own seminars" do
      assert @ability.can?(:destroy, Factory(:seminar, :user => @user))
    end
    
    should "be unable to destroy seminars from someone else" do
      assert !@ability.can?(:destroy, Factory(:seminar, :user => Factory(:user)))
    end
    
    should "be unable to create categories" do
      assert !@ability.can?(:create, Category)
    end
    
    context "and a building," do
      setup do
        @building = Factory(:building)
      end
    
      should "be able to destroy the building" do
        assert @ability.can?(:destroy, @building)
      end
      
      context "with a location" do
        setup do
          @location = Factory(:location, :building_id => @building.id)
          @building.reload
        end
    
        should "be able to destroy the location" do
          assert @ability.can?(:destroy, @location)
        end
        
        should "not be able to destroy the building" do
          assert !@ability.can?(:destroy, @building)
        end
        
        should "have a location" do
          assert !@building.locations.blank?
        end
        
        context "and a seminar," do
          setup do
            @seminar = Factory(:seminar, :location => @location, :user => @user)
            @location.reload
          end
    
          should "be able to destroy the seminar" do
            assert @ability.can?(:destroy, @seminar)
          end
        
          should "not be able to destroy the location" do
            assert !@ability.can?(:destroy, @location)
          end
        end
        
      end
    end
    
    context ", and a category" do
      setup do
        @category = Factory :category
      end
        
      should "not be able to destroy the category" do
        assert !@ability.can?(:destroy, @category)
      end
    end
  end
  
  context "A admin user," do
    setup do
      @user = Factory :user, :admin => true
      @ability = Ability.new(@user)
    end
    
    should "be able to create her own seminars" do
      assert @ability.can?(:create, Seminar)
    end
    
    should "be able to edit her own seminars" do
      assert @ability.can?(:update, Factory(:seminar, :user => @user))
    end
    
    should "be able to edit seminars from someone else" do
      assert @ability.can?(:update, Factory(:seminar, :user => Factory(:user)))
    end
    
    should "be able to destroy her own seminars" do
      assert @ability.can?(:destroy, Factory(:seminar, :user => @user))
    end
    
    should "be able to destroy seminars from someone else" do
      assert @ability.can?(:destroy, Factory(:seminar, :user => Factory(:user)))
    end
  end
end
