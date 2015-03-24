# Linked list ADT, copied from
# https://github.com/natefaubion/adt.js#recursive-types
{data, any, only} = require 'adt'

List = data ->
  Nil : null
  Cons :
    head : any
    tail : only this
# The rest of this file I (Dan McDonald) wrote myself

# Create list from Array object
List.fromArray = (arr) ->
  newArr = arr.slice()
  ls = List.Nil
  ls = List.Cons(newArr.pop(), ls) while newArr.length > 0
  ls

List.prototype.concat = (other) ->
  List.fromArray(this.toArray().concat(other.toArray()))

List.prototype.fold = (init, f) ->
  if this.isNil
    init
  else
    this.tail.fold(f(init, this.head), f)

List.prototype.forEach = (f) ->
  if this.isCons
    f(this.head)
    this.tail.forEach(f)

List.prototype.reversed = ->
  helper = (ls, acc) ->
    if ls.isCons
      helper(ls.tail, List.Cons(ls.head, acc))
    else
      acc
  helper(this, List.Nil)

# Number of Cons elements in the list
List.prototype.size = () ->
  # Tail recursive!
  helper = (ls, count) ->
    if ls.equals(List.Nil)
      count
    else
      helper(ls.tail, count+1)
  helper(this, 0)

# Returns a copy of the list sorted using the provided comparison function.
List.prototype.sort = (cmp) ->
  # So we could write our own sorting algorithm here, but JS already provides
  # one for arrays, which is probably faster than anything I could write, so
  # let's just leverage that. We still provide an immutable interface.
  arr = this.toArray()
  arr.sort(cmp)
  List.fromArray(arr)

# Returns the list elements in an Array object
List.prototype.toArray = () ->
  ls = this
  arr = []
  while ls.isCons
    arr.push ls.head
    ls = ls.tail
  arr
