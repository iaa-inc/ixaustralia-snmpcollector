require 'spec_helper'
describe 'snmpcollector' do
  context 'with default values for all parameters' do
    it { should contain_class('snmpcollector') }
  end
end
