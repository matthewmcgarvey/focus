module Focus::Queryable
  abstract def to_sql_with_args : Tuple(String, Array(Focus::Parameter))

  def exec(database : DB::Database | DB::Connection) : DB::ExecResult
    sql, args = to_sql_with_args
    database.exec(sql, args: args.map(&.value))
  end

  def query(database : DB::Database | DB::Connection) : DB::ResultSet
    sql, args = to_sql_with_args
    database.query(sql, args: args.map(&.value))
  end

  def query_all(database : DB::Database | DB::Connection, as types : Tuple)
    sql, args = to_sql_with_args
    database.query_all(sql, args: args.map(&.value), as: types)
  end

  def query_all(database : DB::Database | DB::Connection, as type : NamedTuple)
    sql, args = to_sql_with_args
    database.query_all(sql, args: args.map(&.value), as: type)
  end

  def query_all(database : DB::Database | DB::Connection, as : T.class) : Array(T) forall T
    sql, args = to_sql_with_args
    database.query_all(sql, args: args.map(&.value), as: T)
  end

  def query_one(database : DB::Database | DB::Connection, as type : Tuple)
    sql, args = to_sql_with_args
    database.query_one(sql, args: args.map(&.value), as: type)
  end

  def query_one(database : DB::Database | DB::Connection, as type : NamedTuple)
    sql, args = to_sql_with_args
    database.query_one(sql, args: args.map(&.value), as: type)
  end

  def query_one(database : DB::Database | DB::Connection, as : T.class) : T forall T
    sql, args = to_sql_with_args
    database.query_one(sql, args: args.map(&.value), as: T)
  end

  def query_one?(database : DB::Database | DB::Connection, as type : Tuple)
    sql, args = to_sql_with_args
    database.query_one?(sql, args: args.map(&.value), as: type)
  end

  def query_one?(database : DB::Database | DB::Connection, as type : NamedTuple)
    sql, args = to_sql_with_args
    database.query_one?(sql, args: args.map(&.value), as: type)
  end

  def query_one?(database : DB::Database | DB::Connection, as : T.class) : T? forall T
    sql, args = to_sql_with_args
    database.query_one?(sql, args: args.map(&.value), as: T)
  end
end
