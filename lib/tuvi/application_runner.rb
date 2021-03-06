class ApplicationRunner

  def initialize(steps)
    @steps = steps
  end

  def run
    puts "Welcome! Type 'exit' to quit at any time."
    current_step_id = "start"
    while true do
      current_step_id = execute_step(current_step_id)
    end
  end

  def execute_step(step_id)
    current_step = @steps[step_id]
    current_step.code_blocks.each do |block|
      block.call
    end
    puts
    puts current_step.get_say
    exit if current_step.exit_program
    puts current_step.formatted_responses
    input = gets.downcase.chomp
    exit_program if input == "exit"
    determine_next_step(current_step, input)
  end

  def determine_next_step(current_step, input)
    if current_step.response_paths[input]
      return current_step.response_paths[input]
    end

    puts "Sorry, I don't understand that response. Please try again:"
    current_step.id
  end

  def exit_program
    puts "Bye!"
    exit
  end
end