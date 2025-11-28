module Focus::Queryable
  abstract def format_expression : Tuple(String, Array(Focus::BaseArgumentExpression))

  def exec(database : DB::Database | DB::Connection) : DB::ExecResult
    sql, args = format_expression
    database.exec(sql, args: args.map(&.value))
  end

  def query(database : DB::Database | DB::Connection) : DB::ResultSet
    sql, args = format_expression
    database.query(sql, args: args.map(&.value))
  end

  def query_all(database : DB::Database | DB::Connection, as types : Tuple)
    sql, args = format_expression
    database.query_all(sql, args: args.map(&.value), as: types)
  end

  def query_all(database : DB::Database | DB::Connection, as type : NamedTuple)
    sql, args = format_expression
    database.query_all(sql, args: args.map(&.value), as: type)
  end

  def query_all(database : DB::Database | DB::Connection, as : T.class) : Array(T) forall T
    sql, args = format_expression
    database.query_all(sql, args: args.map(&.value), as: T)
  end

  def query_one(database : DB::Database | DB::Connection, as type : Tuple)
    sql, args = format_expression
    database.query_one(sql, args: args.map(&.value), as: type)
  end

  def query_one(database : DB::Database | DB::Connection, as type : NamedTuple)
    sql, args = format_expression
    database.query_one(sql, args: args.map(&.value), as: type)
  end

  def query_one(database : DB::Database | DB::Connection, as : T.class) : T forall T
    sql, args = format_expression
    database.query_one(sql, args: args.map(&.value), as: T)
  end

  def query_one?(database : DB::Database | DB::Connection, as type : Tuple)
    sql, args = format_expression
    database.query_one?(sql, args: args.map(&.value), as: type)
  end

  def query_one?(database : DB::Database | DB::Connection, as type : NamedTuple)
    sql, args = format_expression
    database.query_one?(sql, args: args.map(&.value), as: type)
  end

  def query_one?(database : DB::Database | DB::Connection, as : T.class) : T? forall T
    sql, args = format_expression
    database.query_one?(sql, args: args.map(&.value), as: T)
  end
end
