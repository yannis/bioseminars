RSpec::Matchers.define :allow_action do |*args|
  match do |permission|
    permission.allow_action?(*args).should be_true
  end
end

RSpec::Matchers.define :allow_param do |*args|
  match do |permission|
    permission.allow_param?(*args).should be_true
  end
end
