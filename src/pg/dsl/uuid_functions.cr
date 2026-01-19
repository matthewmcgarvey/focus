module Focus::PG::Dsl::UuidFunctions
  def gen_random_uuid : Focus::StringExpression
    func = Focus::FunctionExpression.new("gen_random_uuid", parameters: [] of Focus::Expression)
    Focus::StringExpression.new(func)
  end

  def uuidv4 : Focus::StringExpression
    func = Focus::FunctionExpression.new("uuidv4", parameters: [] of Focus::Expression)
    Focus::StringExpression.new(func)
  end

  def uuidv7 : Focus::StringExpression
    func = Focus::FunctionExpression.new("uuidv7", parameters: [] of Focus::Expression)
    Focus::StringExpression.new(func)
  end
end
