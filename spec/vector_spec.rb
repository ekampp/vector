require "rspec"
require "matrix"

Point = Struct.new(:x, :y, :z)

# VectorIntersect is an emphemeral class designed to determine geometric
# qualities of line representation of vectors. This means spacial intersection,
# slope etc.
# This can be considered an extension to Ruby's build-in Vector class.
#
class VectorIntersect
  attr_reader :v1, :v2, :p1, :p2

  # Supply a vector, +v1+ and a correponding point on the line, +p1+; as well as
  # another vector, +v2+ and a point on that line, +p2+
  #
  # Constructs an instance of VectorIntersect, which can be used to determine if
  # the given vectors, +v1+ and +v2+ intersect each other.
  #
  def initialize(v1, p1, v2, p2)
    @v1, @v2, @p1, @p2 = v1, v2, p1, p2
  end

  # Predicate method to quickly determine if the vectors +v1+ and +v2+ intersect
  # each other.
  #
  def intersect?
    intersect_matrix.determinant === 0
  end

  # Determine the exact coordinates for any intersection between vectors +v1+
  # and +v2+
  #
  def intersect
    lx = lambda do |v, p, t|
      p.x + v*t
    end
  end

private

  # Return a matrix of any potential intersection between the vectors +v1+ and
  # +v2+
  #
  def intersect_matrix
    @intersect_matrix ||= Matrix[
      [p2.x-p1.x, p2.y-p1.y, p2.z-p1.z],
      [v1[0], v1[1], v1[2]],
      [v2[0], v2[1], v2[2]],
    ]
  end
end

describe VectorIntersect do
  describe "#new" do
    let(:p1) { Point.new(0,0,0) }
    let(:p2) { Point.new(2,0,0) }
    let(:p3) { Point.new(0,0,1) }
    let(:p4) { Point.new(0,2,1) }
    let (:v1) { Vector[p2.x-p1.x, p2.y-p1.y, p2.z-p1.z] }
    let (:v2) { Vector[p4.x-p3.x, p4.y-p3.y, p4.z-p3.z] }
    subject { VectorIntersect.new(v1, p2, v2, p4) }
    it { expect { subject }.not_to raise_error }
    its(:v1) { should eq(v1) }
    its(:v2) { should eq(v2) }
    its(:p1) { should eq(p2) }
    its(:p2) { should eq(p4) }
  end

  describe "intersect?" do
    let (:v1) { Vector[p2.x-p1.x, p2.y-p1.y, p2.z-p1.z] }
    let (:v2) { Vector[p4.x-p3.x, p4.y-p3.y, p4.z-p3.z] }
    subject { VectorIntersect.new(v1, p2, v2, p4).intersect? }

    context "non-intersecting lines" do
      let(:p1) { Point.new(0,0,0) }
      let(:p2) { Point.new(2,0,0) }
      let(:p3) { Point.new(0,0,1) }
      let(:p4) { Point.new(0,2,1) }
      it { should eql(false) }
    end

    context "intersecting lines" do
      let(:p1) { Point.new(0,0,0) }
      let(:p2) { Point.new(2,0,0) }
      let(:p3) { Point.new(0,0,0) }
      let(:p4) { Point.new(0,2,0) }
      it { should eql(true) }
    end
  end

  describe "#intersect" do
    let (:v1) { Vector[p2.x-p1.x, p2.y-p1.y, p2.z-p1.z] }
    let (:v2) { Vector[p4.x-p3.x, p4.y-p3.y, p4.z-p3.z] }
    subject { VectorIntersect.new(v1, p2, v2, p4).intersect }

    context "non-intersecting lines" do
      let(:p1) { Point.new(0,0,0) }
      let(:p2) { Point.new(2,0,0) }
      let(:p3) { Point.new(0,0,1) }
      let(:p4) { Point.new(0,2,1) }
      it { should eql(nil) }
    end

    context "intersecting lines" do
      let(:p1) { Point.new(0,0,0) }
      let(:p2) { Point.new(2,0,0) }
      let(:p3) { Point.new(0,0,0) }
      let(:p4) { Point.new(0,2,0) }
      it { should eql([0,0,0]) }
    end
  end
end
