class MainCommand < Cling::Command
  def setup : Nil
    @name = "focus"
    add_option 'h', "help", description: "sends help information"
  end

  def pre_run(arguments : Cling::Arguments, options : Cling::Options) : Nil
    if options.has? "help"
      puts help_template # generated using Cling::Formatter
      exit_program 0     # exit code 0 for successful
    end
  end

  def run(arguments : Cling::Arguments, options : Cling::Options) : Nil
    # do nothing
  end
end
