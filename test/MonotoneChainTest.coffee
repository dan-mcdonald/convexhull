expect = require("chai").expect
_ = require("underscore")
{List, Point, monotoneChain} = require("../lib/lib")

describe('monotone chain', ->
  nineByNine = List.fromArray(
    (for x in _.range(10)
      for y in _.range(10)
        Point(x, y)
    ).reduce((a, b) -> a.concat(b))
  )
  it('should work on a 9x9 grid', ->
    expect(monotoneChain(nineByNine)).to.deep.equal(List.fromArray(
      [Point(0, 9), Point(9, 9), Point(9, 0), Point(0, 0)]
    ))
  )
  it('should gracefully handle duplicate points', ->
    nineByNineWithDupe = List.Cons(Point(0, 9), nineByNine)
    expect(monotoneChain(nineByNine)).to.deep.equal(List.fromArray(
      [Point(0, 9), Point(9, 9), Point(9, 0), Point(0, 0)]
    ))
  )
  it('should refuse to process less than three distinct points', ->
    badPoints = List.Cons(Point(0, 0), List.Cons(Point(1, 1),
      List.Cons(Point(0, 0), List.Nil)))
    expect(-> monotoneChain(badPoints)).to.throw(Error)
  )
)
