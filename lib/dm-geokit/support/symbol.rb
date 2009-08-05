class Symbol
  
  def near
    DataMapper::GeoKit::DistanceOperator.new(self, :near)
  end

  def outside
    DataMapper::GeoKit::DistanceOperator.new(self, :outside)
  end

end
