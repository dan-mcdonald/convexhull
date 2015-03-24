Promise = require('promise')
readline = require('readline')
stream = require("stream")

# Takes an input Stream and returns a Promise that resolves to a List of Points
# in reverse order of input. Input Stream should be one space-separated
# coordinate pair per line.
parsePointStream = (input) ->
  return new Promise((resolve, reject) ->
    rl = readline.createInterface({input: input})

    # readline interfaces implement Node's EventEmitter API, which is inherently
    # a mutating API. So we don't mutate any variables but we do have to
    # use the EventEmitter API. It would be interesting to try to write a
    # wrapper that provides an immutable API around EventEmitters.
    setListeners = (lineNumber, points) ->
      rl.removeAllListeners('close')
      rl.on('close', -> resolve(points))
      rl.once('line', parsePoint(lineNumber, points))

    parsePoint = (lineNumber, points) ->
      (line) ->
        values = line.split(" ").filter((x) -> x.length).map(Number)
        if(!values.every(isFinite) || values.length != 2)
          reject("Point line #{lineNumber} (#{line}) is not a pair of floats")
        point = Point.apply(this, values)
        newPoints = List.Cons(point, points)
        setListeners(lineNumber+1, newPoints)

    setListeners(1, List.Nil)
  )

exportPointStream = (output, points) ->
  return new Promise((resolve, reject) ->
    # returns a function that will write the next line and make sure to write
    # remaining lines
    buildWriter = (remainingPoints) ->
      ->
        if remainingPoints.isNil
          resolve(true)
        else
          point = remainingPoints.head
          rest = remainingPoints.tail
          line = "#{point.x} #{point.y}\n"
          writer = buildWriter(rest)
          if output.write(line)
            writer()
          else
            output.once('drain', writer)
    buildWriter(points)()
  )
