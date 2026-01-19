class Focus::PG::Dialect < Focus::Dialect
  def initialize
    super(name: "PG", package_name: "pg")
  end

  def formatter : Focus::SqlFormatter
    Focus::PG::Formatter.new
  end
end
