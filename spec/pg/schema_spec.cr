require "../pg_spec_helper"

class Product
  include DB::Serializable

  property id : Int32
  property sku : String
  property name : String
  property description : String?
  property price : Float64
  property quantity : Int32
  property is_active : Bool
  property created_at : Time
end

describe "PG Queries with schema" do
  context "select" do
    it "selects all products from inventory schema" do
      query = Products.select
        .order_by(Products.id.asc)
      query.to_sql.should eq("SELECT * FROM inventory.products ORDER BY products.id ASC")
      products = query.query_all(PG_DATABASE, as: Product)

      products.size.should eq(3)
      products[0].sku.should eq("SKU-001")
      products[1].sku.should eq("SKU-002")
      products[2].sku.should eq("SKU-003")
    end

    it "selects product by sku" do
      query = Products.select
        .where(Products.sku.eq(Focus::PG.string("SKU-002")))
      query.to_sql.should eq("SELECT * FROM inventory.products WHERE (products.sku = $1)")
      product = query.query_one(PG_DATABASE, as: Product)

      product.name.should eq("Mechanical Keyboard")
      product.price.to_f.should eq(89.99)
      product.quantity.should eq(75)
    end

    it "filters active products" do
      active_products = Products.select(Products.sku, Products.name)
        .where(Products.is_active.eq(Focus::PG.bool(true)))
        .order_by(Products.id.asc)
        .query_all(PG_DATABASE, as: {sku: String, name: String})

      active_products.size.should eq(2)
      active_products[0][:sku].should eq("SKU-001")
      active_products[1][:sku].should eq("SKU-002")
    end

    it "filters products by price range" do
      products = Products.select(Products.name, Products.price)
        .where(Products.price.greater_than(Focus::PG.float64(30.0)))
        .order_by(Products.price.asc)
        .query_all(PG_DATABASE, as: {name: String, price: Float64})

      products.size.should eq(2)
      products[0][:name].should eq("USB-C Hub")
      products[1][:name].should eq("Mechanical Keyboard")
    end

    it "counts products in stock" do
      count = Products.select(Focus::PG.count(Products.id))
        .where(Products.quantity.greater_than(Focus::PG.int32(0)))
        .query_one(PG_DATABASE, as: Int64)

      count.should eq(2)
    end

    it "uses table alias with schema-qualified table" do
      p = Products.aliased("p")
      stmt = Focus::PG.select(p.name, p.price)
        .from(p)
        .where(p.is_active.eq(Focus::PG.bool(true)))
        .order_by(p.price.asc)

      expected_sql = formatted(<<-SQL)
        SELECT p.name, p.price FROM inventory.products p
        WHERE (p.is_active = $1)
        ORDER BY p.price ASC
      SQL
      stmt.to_sql.should eq(expected_sql)

      results = stmt.query_all(PG_DATABASE, as: {name: String, price: Float64})
      results.should eq([
        {name: "Wireless Mouse", price: 29.99},
        {name: "Mechanical Keyboard", price: 89.99},
      ])
    end
  end

  context "insert" do
    it "with correct schema" do
      in_transaction do |db|
        Products.insert(
          Products.sku,
          Products.name,
          Products.description,
          Products.price,
          Products.quantity
        ).values("SKU-TEST", "Test Product", "A test product", 9.99, 10).exec(db)

        product = Products.select
          .where(Products.sku.eq(Focus::PG.string("SKU-TEST")))
          .query_one(db, as: Product)

        product.name.should eq("Test Product")
      end
    end
  end
end
