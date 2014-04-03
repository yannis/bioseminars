shared_examples "a model with permissions" do

  context "it has permissions" do
    it {should respond_to :readable?}
    it {should respond_to :readable_by?}
    it {should respond_to :updatable?}
    it {should respond_to :updatable_by?}
    it {should respond_to :destroyable?}
    it {should respond_to :destroyable_by?}
  end
end
