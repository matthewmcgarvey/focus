class Focus::BoolColumn < Focus::Column
  scalar_wrappers(Bool, Focus::GenericValueExpression(Bool), :eq)
end
