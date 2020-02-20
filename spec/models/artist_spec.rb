require 'rails_helper'

describe Artist do
  it { should have_many(:albums) }
end
