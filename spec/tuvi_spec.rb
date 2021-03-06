require 'spec_helper'

describe Tuvi do

  class Program
    include Tuvi
  end

  before(:each) do
    @program = Program.new
  end

  describe "Step syntax" do

    describe "step" do

      it "should return a new step" do
        @program.step(1)
        @program.instance_eval{@steps[1]}.class.should == Step
      end

      it "should assign number parameter to step's id" do
        @program.step(1)
        @program.instance_eval{@steps[1]}.id.should == 1
      end

    end

    describe "say" do

      it "should assign a say based on say passed in block" do
        @program.step(1){say "Hello!"}
        @program.instance_eval{@steps[1]}.get_say.should == "Hello!"
      end

    end

    describe "response" do

      it "should create an response path with the key and the key should be downcased" do
        @program.step(1){response "Yes" => 2}
        @program.instance_eval{@steps[1]}.response_paths["yes"].should == 2
      end

    end

    describe "stop" do

      it "should mark a step as exit_program if 'stop' is passed in block" do
        @program.step(1){stop}
        @program.instance_eval{@steps[1]}.exit_program.should be_true
      end

    end

    describe "code" do

      it "should add blocks to the step's code_blocks" do
        @program.step(1){code {puts "Hello"} }
        @program.instance_eval{@steps[1]}.code_blocks[0].should be_a Proc
      end

    end

  end

end