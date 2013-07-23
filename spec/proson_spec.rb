require 'rspec'
require_relative '../lib/proson'

class Example < Proson
  json_attr :key1
  json_attr :key2, :key3
end

describe Proson do

  describe "#json_attr" do

    it "should define a getter for each json attr" do
      example = Example.new()
      example.should respond_to(:key1)
    end

    it "should define a setter for each json attr" do
      example = Example.new()
      example.should respond_to(:key1=)
    end

    it "should accept multiple arguments" do
      example = Example.new()
      example.should respond_to(:key3)
      example.should respond_to(:key3=)
    end

  end

  describe "hash initialization" do

    it "should accept a hash" do
      expect {
        Example.new({})
      }.to_not raise_exception
    end

    it "should load attributes from the hash" do
      example = Example.new({ :key1 => 'value1' })
      example.key1.should == 'value1'
    end

    it "should load attributes from the hash with string keys" do
      example = Example.new({ 'key1' => 'value1' })
      example.key1.should == 'value1'
    end

  end

  describe "json string initialization" do

    it "should accept a valid json string" do
      expect {
        Example.new('{}')
      }.to_not raise_exception
    end

    it "should load attributes from the json" do
      example = Example.new('{ "key1": "value1" }')
      example.key1.should == 'value1'
    end

    it "should raise an exception for an invalid json string" do
      expect {
        Example.new('this is not valid json')
      }.to raise_exception
    end

  end

  describe "#parse" do

    context "with hash" do

      it "should initialise a new object with the hash" do
        example = Example.parse({key1: 'value1'})
        example.should be_a Example
      end

    end

    context "with array" do

      it "should return an array of instances" do
        example = Example.parse([{ key1: 'value1' }, '{ "key1": "value1" }'])
        example.should be_a Array
        example.each { |i| i.should be_a Example }
      end

    end

    context "with string" do

      it "should initialise a new object with the hash" do
        example = Example.parse('{ "key1": "value1" }')
        example.should be_a Example
      end

    end

  end

end