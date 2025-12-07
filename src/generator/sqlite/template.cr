class Focus::Template
  def self.dialect(dialect : Focus::Dialect) : Template
    new(dialect)
  end

  getter dialect : Focus::Dialect

  def initialize(@dialect : Focus::Dialect)
  end
end
