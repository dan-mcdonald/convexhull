expect = require('chai').expect
List = require("../lib/lib").List

describe('List', () ->
  describe('fromArray', () ->
    it("should handle empty array", () ->
      expect(List.fromArray([])).to.deep.equal(List.Nil)
    )
    it("should handle array of numbers", () ->
      expect(List.fromArray([1, 2, 3])).to.deep.equal(
        List.Cons(1, List.Cons(2, List.Cons(3, List.Nil)))
      )
    )
  )

  describe('#size', () ->
    it('should handle empty List', () ->
      expect(List.Nil.size()).to.equal(0)
    )
    it('should handle List of numbers', () ->
      expect(
        List.Cons(1, List.Cons(2, List.Cons(3, List.Nil))).size()
      ).to.equal(3)
    )
  )

  describe('#sort', () ->
    numeric = (x, y) -> x - y
    it("should handle empty List", () ->
      expect(List.Nil.sort(numeric)).to.deep.equal(List.Nil)
    )
    it("should handle sorted List", () ->
      expect(
        List.Cons(1, List.Cons(2, List.Cons(3, List.Nil))).sort(numeric)
      ).to.deep.equal(
        List.Cons(1, List.Cons(2, List.Cons(3, List.Nil)))
      )
    )
    it("should handle unsorted List", () ->
      expect(
        List.Cons(3, List.Cons(1, List.Cons(2, List.Nil))).sort(numeric)
      ).to.deep.equal(
        List.Cons(1, List.Cons(2, List.Cons(3, List.Nil)))
      )
    )
  )

  describe('#toArray', () ->
    it("should handle empty List", () ->
      expect(List.Nil.toArray()).to.deep.equal([])
    )
    it("should handle List of numbers", () ->
      expect(
        List.Cons(1, List.Cons(2, List.Cons(3, List.Nil))).toArray()
      ).to.deep.equal([1, 2, 3])
    )
  )

)
