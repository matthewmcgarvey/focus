require "./test_base"

abstract class ExecutingTestBase < TestBase
  abstract def database : DB::Database

  def execute(sql : Focus::SelectQuery)
    sql.query(database)
  end

  def exec_sql_script(filename : String)
    database.using_connection do |conn|
      raw_sql = File.read(filename)
      raw_sql.split(';')
        .compact_map(&.presence)
        .each { |sql_stmt| conn.exec sql_stmt }
    end
  end
end
