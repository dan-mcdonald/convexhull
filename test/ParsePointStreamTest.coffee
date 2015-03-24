expect = require("chai").expect

stream = require("stream")
mod = require("../lib/lib")

describe('parsePointStream()', () ->
  it('should correctly parse 10 2D integers', (done) ->
    s = new stream.Readable()
    s.push("""
    -999984 -736924
    511211 -82700
    65534 -562082
    -905911 357729
    358593 869386
    -232996 38833
    661931 -930856
    -893077 59400
    342299 -984604
    -233169 -866316
    """)
    s.push(null)
    mod.parsePointStream(s).done(
      (pointsList) ->
        pointsArray = pointsList.toArray()
        expect(pointsArray).to.deep.equal([
          {x:-233169, y:-866316},
          {x:342299, y:-984604},
          {x:-893077, y:59400},
          {x:661931, y:-930856},
          {x:-232996, y:38833},
          {x:358593, y:869386},
          {x:-905911, y:357729},
          {x:65534, y:-562082},
          {x:511211, y:-82700},
          {x:-999984, y:-736924},
        ])
        done()
      , (err) -> throw err
    )
  )
  it('should correctly parse 5 2D floats with trailing whitespace', (done) ->
    s = new stream.Readable()
    # coffeelint: disable=no_trailing_whitespace
    s.push("""
    -0.0222149361131852 -0.366434993563625 
    -0.06676722137887703 -0.1566931052661437 
    0.02820502736438535 0.04189077954915421 
    0.3126723396709863 0.08400649026409401 
    0.1781470954214661 0.1182274414396169 
    """)
    # coffeelint: enable=no_trailing_whitespace
    s.push(null)
    mod.parsePointStream(s).done(
      (pointsList) ->
        pointsArray = pointsList.toArray()
        expect(pointsArray).to.deep.equal([
          {x:0.1781470954214661, y:0.1182274414396169},
          {x:0.3126723396709863, y:0.08400649026409401},
          {x:0.02820502736438535, y:0.04189077954915421},
          {x:-0.06676722137887703, y:-0.1566931052661437},
          {x:-0.0222149361131852, y:-0.366434993563625},
        ])
        done()
      , (err) -> throw err
    )
  )
)
