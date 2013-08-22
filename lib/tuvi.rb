require_relative "tuvi/version"
require_relative "tuvi/step"
require 'ostruct'

module Tuvi

  def step(id, &block)
    @steps ||= {}
    @steps[id] = Step.new(id, &block)
  end

  def run
    current_step_id = 1
    while true do
      current_step_id = execute_step(current_step_id)
    end
  end

  def execute_step(step_id)
    current_step = @steps[step_id]
    current_step.code_blocks.each do |block|
      block.call
    end
    puts current_step.get_message
    exit if current_step.exit_program
    puts current_step.formatted_answers
    input = gets.downcase.chomp
    exit_program if input == "exit"
    determine_next_step(current_step, input)
  end

  def determine_next_step(current_step, input)
    if current_step.answer_paths[input]
      return current_step.answer_paths[input]
    end

    # Allow for extensions
    next_step_id = run_extensions(current_step, input) if respond_to?(:run_extensions)
    return next_step_id if next_step_id

    puts "Sorry, I don't understand that answer. Please try again:"
    current_step.id
  end

  def exit_program
    puts "Bye!"
    exit
  end

end

extend Tuvi
