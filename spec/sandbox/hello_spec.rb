# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Hello World' do
  it 'returns a greeting message' do
    greeting = 'Hello, World!'
    expect(greeting).to eq('Hello, World!')
  end

  it 'concatenates strings' do
    name = 'Alice'
    greeting = "Hello, #{name}!"
    expect(greeting).to eq('Hello, Alice!')
  end
end
