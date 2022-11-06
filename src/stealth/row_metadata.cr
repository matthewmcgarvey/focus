class Stealth::RowMetadata
  getter fields : Array(Stealth::BaseField)

  def initialize(@fields)
  end
end
