module Focus::Sql
  abstract struct Token
  end

  record Keyword < Token, text : String
  record Identifier < Token, name : String, schema : String? = nil, table : String? = nil
  record Operator < Token, text : String
  record Placeholder < Token, value : DB::Any
  record Literal < Token, text : String
  record GroupStart < Token, char : Char = '('
  record GroupEnd < Token, char : Char = ')'
  record ListSeparator < Token
end
