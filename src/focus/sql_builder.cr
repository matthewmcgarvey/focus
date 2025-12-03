class Focus::SqlBuilder
  private getter io : IO

  def initialize(@io : IO)
  end

  def write(str : String) : Nil
    io << str
  end
end
