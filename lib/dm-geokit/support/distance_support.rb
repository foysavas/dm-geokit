module DistanceSupport

  def mi
    DistanceMeasurement.new(self, :miles)
  end

  def km
    DistanceMeasurement.new(self, :kms)
  end

end
