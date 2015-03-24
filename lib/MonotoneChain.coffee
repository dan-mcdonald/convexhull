_ = require('underscore')

# Implements Andrew's monotone chain convex hull algorithm
# http://en.wikibooks.org/wiki/Algorithm_Implementation/Geometry/Convex_hull/Monotone_chain#Pseudo-code
# This algorithm is slightly better than a Graham Scan because the sorting
# comparison function is less expensive, but still in O(n log n) from sort.
monotoneChain = (unsortedPoints) ->
  # Sort the points of P by x-coordinate (in case of a tie, sort by
  # y-coordinate).
  sorted = unsortedPoints.sort((a, b) -> (a.x - b.x) || (a.y - b.y))

  # Remove duplicates
  P = sorted.fold(List.Nil, (ls, x) ->
    if ls.isCons and _.isEqual(ls.head, x)
      ls
    else
      List.Cons(x, ls)
  ).reversed()

  if P.isNil or P.tail.isNil or P.tail.tail.isNil
    throw new Error("Input list must contain at least 3 distinct points")

  halfHull = (points, hull = List.Nil) ->
    if points.isNil
      # all points processed, we should be left with the half hull now
      hull
    else
      p = points.head
      # If the current point is clockwise with the last two points in hull
      if (hull.isCons and hull.tail.isCons and
          clockwise(hull.tail.head, hull.head, p))
        # then the last hull point doesn't belong in hull
        halfHull(points, hull.tail)
      else
        # otherwise this point looks like it is part of the hull
        halfHull(points.tail, List.Cons(p, hull))

  lower = halfHull(P)
  upper = halfHull(P.reversed())

  upper.tail.concat(lower.tail)

difference = (a, b) ->
  Point(a.x - b.x, a.y - b.y)

crossProduct = (a, b) ->
  a.x * b.y - b.x * a.y

# Checks whether it is shorter to rotate from OA to OB clockwise than counter-
# clockwise.
clockwise = (o, a, b) ->
  crossProduct(difference(a, o), difference(b, o)) <= 0
