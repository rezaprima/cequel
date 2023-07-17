# -*- encoding : utf-8 -*-
require_relative 'spec_helper'

describe 'serialization' do
  model :Post do
    key :blog_subdomain, :text
    key :id, :uuid, auto: true
    column :title, :text
    column :body, :text
  end

  uuid :id

  let(:attributes) do
    {
      blog_subdomain: 'big-data',
      id: id,
      title: 'Cequel',
    }
  end

  let(:post){ Post.new(attributes) }

  before :each do
    Post.include_root_in_json = false
  end

  it 'should provide JSON serialization' do
    json = post.as_json.symbolize_keys
    expect(json.keys).to eq([:blog_subdomain, :title, :body, :id])
    expect(json[:body]).to be_nil
    expect(json[:id].has_key?('n')).to be true
    expect(Cassandra::TimeUuid.new(json[:id]['n']).to_time).to eq(post.id.to_time)
  end

  it 'should be able to serialize restricting to some attributes' do
    json = post.as_json(only: [:id]).symbolize_keys
    expect(json[:id].has_key?('n')).to be true
    expect(json[:id].has_key?('n')).to be true
    expect(Cassandra::TimeUuid.new(json[:id]['n']).to_time).to eq(post.id.to_time)
  end
end
