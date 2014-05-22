# Vector

This is a class extension, allowing a better, faster way to work with vectors in Ruby.

Currently it exposes the following, additional methods on the Vector class:

## Vector#intersect?(p1, v2, p2)

Which takes a point on the current vector, `p1`, another vector (`v2`) and a point on that second vector (`p2`). This will then determine if those vectors intersect at any point in their direction.