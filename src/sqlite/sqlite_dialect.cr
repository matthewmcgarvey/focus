class Focus::SQLiteDialect < Focus::Dialect
  def initialize
    super(name: "SQLite", package_name: "sqlite")
  end

  def formatter : Focus::SqlFormatter
    Focus::SQLiteFormatter.new
  end
end
