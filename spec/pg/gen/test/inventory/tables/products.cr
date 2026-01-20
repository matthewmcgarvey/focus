module Gen::Test::Inventory::Tables
  class ProductsTable < Focus::PG::Table
    getter id : Focus::IntColumn(Int32)
    getter sku : Focus::StringColumn
    getter name : Focus::StringColumn
    getter description : Focus::StringColumn
    getter price : Focus::FloatColumn(Float64)
    getter quantity : Focus::IntColumn(Int32)
    getter is_active : Focus::BoolColumn
    getter created_at : Focus::TimestampColumn

    def initialize(schema_name : String? = "inventory", table_name : String = "products", table_alias : String? = nil)
      @id = Focus::IntColumn(Int32).new("id", table_name)
      @sku = Focus::StringColumn.new("sku", table_name)
      @name = Focus::StringColumn.new("name", table_name)
      @description = Focus::StringColumn.new("description", table_name)
      @price = Focus::FloatColumn(Float64).new("price", table_name)
      @quantity = Focus::IntColumn(Int32).new("quantity", table_name)
      @is_active = Focus::BoolColumn.new("is_active", table_name)
      @created_at = Focus::TimestampColumn.new("created_at", table_name)
      columns = [@id, @sku, @name, @description, @price, @quantity, @is_active, @created_at].select(Focus::Expression)

      super(
       schema_name: schema_name,
       table_name: table_name,
       table_alias: table_alias,
       columns: columns
      )
    end
  end

  Products = ProductsTable.new
end
