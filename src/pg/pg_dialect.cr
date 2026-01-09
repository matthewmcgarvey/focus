class Focus::PGDialect < Focus::Dialect
  def initialize
    super(name: "PG", package_name: "pg")
  end
end
