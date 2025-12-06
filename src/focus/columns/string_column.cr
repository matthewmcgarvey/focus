class Focus::StringColumn < Focus::Column
  scalar_wrappers(String, Focus::GenericValueExpression(String), :eq)
end
