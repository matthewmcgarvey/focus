class Focus::Int32Column < Focus::Column
  scalar_wrappers(Int32, Focus::Int32Expression, :eq, :greater_than)
end
