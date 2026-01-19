class Focus::SQLite::Dialect < Focus::Dialect
  def initialize
    super(name: "SQLite", package_name: "sqlite")
  end

  def formatter : Focus::SqlFormatter
    Focus::SQLite::Formatter.new
  end
end
