
global.assert = require 'assert'


global.itShouldNot = (description, itFunc, expected) ->

  assert expected, "Empty expected error message in itShouldNot: #{ expected }.\n Check your indentation"

  it "should not #{ description }", ->

    err = null
    try
      itFunc()
    catch e
      err = e
    finally
      actual = err?.message
      assert actual == expected, "expected to fail with error:\n #{ expected }\n but got \n #{ actual }"