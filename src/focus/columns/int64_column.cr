class Focus::Int64Column < Focus::Column
  scalar_wrappers(Int64, Focus::Int64Expression, :eq, :greater_than)
end
