class Focus::SQLite::Dialect < Focus::Dialect
  def initialize
    super(name: "SQLite", package_name: "sqlite")
  end

  def formatter : Focus::SqlVisitor
    token_formatter
  end

  def old_formatter : Focus::SqlFormatter
    Focus::SQLite::Formatter.new
  end

  def token_formatter : Focus::TokenFormatter
    Focus::SQLite::TokenFormatter.new
  end
end
