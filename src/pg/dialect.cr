class Focus::PG::Dialect < Focus::Dialect
  def initialize
    super(name: "PG", package_name: "pg")
  end

  def formatter : Focus::SqlVisitor
    token_formatter
  end

  def old_formatter : Focus::SqlFormatter
    Focus::PG::Formatter.new
  end

  def token_formatter : Focus::TokenFormatter
    Focus::PG::TokenFormatter.new
  end
end
