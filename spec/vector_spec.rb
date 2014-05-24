require "rspec"
require "matrix"

Point = Struct.new(:x, :y, :z)

# VectorIntersect is an emphemeral class designed to determine geometric
# qualities of line representation of vectors. This means spacial intersection,
# slope etc.
# This can be considered an extension to Ruby's build-in Vector class.
#
class Vector
  # Predicate method to quickly determine if the vectors +v1+ and +v2+ intersect
  # each other.
  #
  def intersect?(p1, v2, p2)
    intersect_matrix(p1, v2, p2).determinant === 0
  end

  # Determine the exact coordinates for any intersection between vectors +v1+
  # and +v2+.
  #
  # Unless the vectors, v1 and v2 actually intersect, this will return the
  # +:no_intersect+ symbol. Returning a symbol triggers a NoMethod error `on
  # :no_intersect`, which means you can trace the `no_intersect` symbol instead
  # of getting a NoMethod error for `nil`.
  #
  # Line1, where a, b, and c is the vector, and x, y, and z is the point.
  # x = x1 + a1 * t1
  # y = y1 + b1 * t1
  # z = z1 + c1 * t1
  #
  # Line2, where a, b, and c is the vector, and x, y, and z is the point.
  # x = x2 + a2 * t2
  # y = y2 + b2 * t2
  # z = z2 + c2 * t2
  #
  def intersect(p1, v2, p2)
    # If this vector and v2 doesn't intersect, return early.
    return :no_intersect unless intersect?(p1, v2, p2)

    # Calculate t2
    # x1 + a1 * t1 = x2 + a2 * t2
    # t1 = (x1 + a2 * t2 + x2) / a1
    # y1 + b1 * (x1 + a2 * x + x2) / a1 = y2 + b2 * x
    # t2 = (a1 * y1 - a1 * y2 + b1 * x1 + b1 * x2) / (a1 * b2 - a2 * b1)
    t2 = (to_a[0] * p1.y - to_a[0] * p2.y + to_a[1] * p1.x + to_a[1] * p2.x) /
         (to_a[0] * v2.to_a[1] - v2.to_a[0] * to_a[1])

    # Use t2 to calculate the intersection
    [
      p2.x + v2.to_a[0] * t2,
      p2.y + v2.to_a[1] * t2,
      p2.z + v2.to_a[2] * t2,
    ]
  end

private

  # Return a matrix of any potential intersection between the vectors +v1+ and
  # +v2+
  #
  def intersect_matrix(p1, v2, p2)
    @intersect_matrix ||= Matrix[
      [p2.x-p1.x, p2.y-p1.y, p2.z-p1.z],
      [self[0], self[1], self[2]],
      [v2[0], v2[1], v2[2]],
    ]
  end
end

describe Vector do
  # Non-intersecting
  let (:niv1) { Vector[2,0,0] }
  let (:niv2) { Vector[0,2,0] }
  let(:nip1) { Point.new(2,0,0) }
  let(:nip2) { Point.new(0,2,1) }

  # Intersecting
  let (:iv1) { Vector[1,0,0] }
  let (:iv2) { Vector[0,1,0] }
  let(:ip1) { Point.new(1,0,1) }
  let(:ip2) { Point.new(1,1,1) }

  describe "intersect?" do
    context "non-intersecting lines" do
      subject { niv1.intersect?(nip1, niv2, nip2) }
      it { should eql(false) }
    end

    context "intersecting lines" do
      subject { iv1.intersect?(ip1, iv2, ip2) }
      it { should eql(true) }
    end
  end

  describe "intersect" do
    context "non-intersecting lines" do
      subject { niv1.intersect(nip1, niv2, nip2) }
      it { should eql(:no_intersect) }
    end

    context "intersecting lines" do
      subject { iv1.intersect(ip1, iv2, ip2) }
      it { should eql([1,0,1]) }
    end
  end
end
