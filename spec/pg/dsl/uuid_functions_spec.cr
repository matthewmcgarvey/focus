require "../../pg_spec_helper"

describe Focus::PG::Dsl::UuidFunctions do
  describe ".gen_random_uuid" do
    it "renders function call" do
      expr = Focus::PG.gen_random_uuid

      visitor = Focus::PG::Formatter.new
      expr.accept(visitor)
      visitor.to_sql.should eq("gen_random_uuid()")
    end
  end

  describe ".uuidv4" do
    it "renders function call" do
      expr = Focus::PG.uuidv4

      visitor = Focus::PG::Formatter.new
      expr.accept(visitor)
      visitor.to_sql.should eq("uuidv4()")
    end
  end

  describe ".uuidv7" do
    it "renders function call" do
      expr = Focus::PG.uuidv7

      visitor = Focus::PG::Formatter.new
      expr.accept(visitor)
      visitor.to_sql.should eq("uuidv7()")
    end
  end

  describe ".string" do
    it "accepts UUID values" do
      uuid = UUID.new("550e8400-e29b-41d4-a716-446655440000")
      expr = Focus::PG.string(uuid)

      visitor = Focus::PG::Formatter.new
      expr.accept(visitor)
      visitor.to_sql.should eq("$1")
      visitor.parameters.should eq(["550e8400-e29b-41d4-a716-446655440000"])
    end
  end
end
