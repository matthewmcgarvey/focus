class Focus::IntColumn(INT_TYPE) < Focus::Column
  scalar_wrappers(INT_TYPE, Focus::IntExpression(INT_TYPE), :eq, :greater_than)
end
