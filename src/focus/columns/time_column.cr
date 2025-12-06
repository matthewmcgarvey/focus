class Focus::TimeColumn < Focus::Column
  scalar_wrappers(Time, Focus::GenericValueExpression(Time), :eq)
end
