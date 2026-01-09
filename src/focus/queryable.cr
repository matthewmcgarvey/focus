module Focus::Queryable
  abstract def to_sql_with_args : Tuple(String, Array(DB::Any))

  def exec(database : Focus::DBConn) : DB::ExecResult
    sql, args = to_sql_with_args
    database.exec(sql, args: args)
  end

  def query(database : Focus::DBConn) : DB::ResultSet
    sql, args = to_sql_with_args
    database.query(sql, args: args)
  end

  def query_all(database : Focus::DBConn, as types : Tuple)
    sql, args = to_sql_with_args
    database.query_all(sql, args: args, as: types)
  end

  def query_all(database : Focus::DBConn, as types : NamedTuple)
    sql, args = to_sql_with_args
    database.query_all(sql, args: args, as: types)
  end

  def query_all(database : Focus::DBConn, as types : Class)
    sql, args = to_sql_with_args
    database.query_all(sql, args: args, as: types)
  end

  def query_one(database : Focus::DBConn, as types : Tuple)
    sql, args = to_sql_with_args
    database.query_one(sql, args: args, as: types)
  end

  def query_one(database : Focus::DBConn, as type : NamedTuple)
    sql, args = to_sql_with_args
    database.query_one(sql, args: args, as: type)
  end

  def query_one(database : Focus::DBConn, as : T.class) : T forall T
    sql, args = to_sql_with_args
    database.query_one(sql, args: args, as: T)
  end

  def query_one?(database : Focus::DBConn, as type : Tuple)
    sql, args = to_sql_with_args
    database.query_one?(sql, args: args, as: type)
  end

  def query_one?(database : Focus::DBConn, as type : NamedTuple)
    sql, args = to_sql_with_args
    database.query_one?(sql, args: args, as: type)
  end

  def query_one?(database : Focus::DBConn, as : T.class) : T? forall T
    sql, args = to_sql_with_args
    database.query_one?(sql, args: args, as: T)
  end
end
