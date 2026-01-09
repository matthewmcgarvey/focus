class Focus::MySqlDialect < Focus::Dialect
  def initialize
    super(name: "MySql", package_name: "mysql")
  end
end
