# As long as I limit usage to block forms I can lean on crystal-db's connection and transaction handling
class Focus::TransactionManager
  private getter raw_db : DB::Database
  private getter current_transaction : DB::Transaction?

  def initialize(@raw_db)
  end

  def with_connection(&block : DB::Connection -> T) : T forall T
    if transaction = current_transaction
      yield transaction.connection
    else
      raw_db.using_connection do |conn|
        yield conn
      end
    end
  end

  def with_transaction(&block : DB::Transaction -> T) : T? forall T
    if transaction = current_transaction
      yield transaction
    else
      raw_db.transaction do |txn|
        begin
          @current_transaction = txn
          yield txn
        ensure
          @current_transaction = nil
        end
      end
    end
  end
end
