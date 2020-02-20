require 'rails_helper'

describe Album do
  it { should have_many(:songs) }
  it { should belong_to(:artist) }
end
