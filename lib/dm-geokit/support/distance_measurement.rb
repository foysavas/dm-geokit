class DistanceMeasurement
  attr_accessor :measurement
  def initialize(value,measurement)
    @value = value.to_f
    @measurement = measurement
  end
  def to_s
    @value.to_s
  end
  def to_i
    @value.to_i
  end
  def to_f
    @value.to_f
  end
end
