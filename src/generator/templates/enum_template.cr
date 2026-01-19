class Focus::Templates::EnumTemplate
  getter module_name : String
  getter dialect : Focus::Dialect
  getter enum_name : String
  getter enum_values : Array(String)

  def initialize(@module_name : String, @dialect : Focus::Dialect, enum_meta : Metadata::Enum)
    @enum_name = enum_meta.name.camelcase
    @enum_values = enum_meta.values
  end

  ECR.def_to_s "#{__DIR__}/enum_template.ecr"
end
