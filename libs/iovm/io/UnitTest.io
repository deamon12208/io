//metadoc UnitTest category Test
/*metadoc UnitTest description
An object for organizing and running unit tests validated by assertions.
*/

//metadoc TestRunner category Testing
/*metadoc TestRunner description
Core testing object responsible for running tests, collected by UnitTests and TestSuites.
*/
TestRunner := Object clone do(
    width ::= 70 # Line width.

    init := method(
        # TestRunner cases is mapping of UnitTest objects to
        # the testSlotNames theese UnitTest objects provide.
        self cases := Map clone
        self exceptions := List clone
        self runtime := 0
    )
//doc TestRunner testCount Returns the number of tests aggregated in this object.
    testCount := method(
        self cases values prepend(0) reduce(
            count, testSlotNames, count + testSlotNames size
        )
    )

//doc TestRunner name Return the name of the TestRunner.
    name := method(
        # If we are running a single test, the the test's name
        # is taken as TestRunner's name, else processed file
        # name is returned.
        name := if(self cases size > 1,
            System launchScript fileName
        ,
            self cases keys first
        )

    )

    linebreak := method(
        if(self ?dots,
            self dots = self dots + 1
         ,
            self dots := 1)
        # Break the line, when the number of dots exceed the
        # predefined line width.
        if(self dots % width == 0, "\n" print)

    )
    success := method(
        "." print
        linebreak
    )
    error := method(name, exc,
        # We need to store both the name of the failed slot and
        # the exception occured, so that we can output them together
        # later on.
        self exceptions append(list(name, exc))
        "E" print
        linebreak
    )

//doc TestRunner run Runs all tests.
    run := method(
        prepare # Prepare is expected to populate tests map.
        self runtime := Date secondsToRun(
            self cases foreach(testCaseName, testSlotNames,
                # Depending on the Lobby is kind of wacky, but that's
                # all we can do, since Map only supports string keys.
                testCase := Lobby getSlot(testCaseName)
                testSlotNames foreach(name,
                    testCase setUp
                    exc := try(stopStatus(testCase doString(name)))
                    if(exc, error(testCaseName .. " " .. name, exc), success)
                    testCase tearDown
                )
            )
        )

        printExceptions
        printSummary
    )

    printExceptions := method(
        "\n" print

        # Printing exceptions in the order they occured.
        exceptions foreach(exc,
            ("=" repeated(width) .. "\nFAIL: " .. exc at(0) .. \
             "\n" .. "-" repeated(width)) println
            exc at(1) showStack
        )
    )

    printSummary := method(
        "-" repeated(width) println
        ("Ran " .. testCount .. " test" .. if(testCount != 1, "s", "") .. \
         " in " .. self runtime .. "\n") println

        result := if(exceptions isNotEmpty,
            "FAILED (failures #{exceptions size})" interpolate
        ,
            "OK")

        (result .. name alignRight(width - result size) .. "\n") println
    )
)

//doc UnitTest setUp Method called prior to each test.
//doc UnitTest tearDown Method called after each test.
//doc UnitTest fail Call to trigger a test failure.
UnitTest := TestRunner clone do(
    setUp := method(nil)
    tearDown := method(nil)

    testSlotNames := method(
        names := self slotNames select(beginsWithSeq("test"))
        if(names isEmpty,
            names
        ,
            names sortByKey(name, self getSlot(name) message lineNumber)
        )
    )

    prepare := method(self cases atPut(self type, testSlotNames))

    fail := method(Exception raise("fail"))

//doc UnitTest assertEquals(a, b) Fail the running test if a != b.
//doc UnitTest assertNotEquals(a, b) Fail the running test if a == b.
//doc UnitTest assertNotSame(a, b) Fail the running test if a != b.
//doc UnitTest assertNil(a) Fail the running test if a != nil.
//doc UnitTest assertNotNil(a) Fail the running test if a == nil.
//doc UnitTest assertTrue(a) Fail the running test if a != true.
//doc UnitTest assertFalse(a) Fail the running test if a != false.
//doc UnitTest assertRaisesException(code) Fail the running test if the code does not raise an Exception.
/*doc UnitTest assertEqualsWithinDelta(expected, actual, delta)
Fail the running test if the expected value is not within delta of the actual value.
*/

    assertEquals := method(a, b, m,
        //writeln("assertEquals1 call message = ", call message type)
        mm := call message
        if(m == nil, m = mm)
        d := m argAt(0) code .. " != " .. call argAt(1) code
        if(a != b, Exception raise("[" .. d .. "] [" .. a asSimpleString .. " != " .. b asSimpleString .. "]"))
        //writeln("assertEquals2")
    )

    assertNotEquals := method(a, b, if(a == b, Exception raise(a asSimpleString .. " == " .. b asSimpleString)))

    assertSame    := method(a, b, assertEquals(a uniqueId, b uniqueId, call message))
    assertNotSame := method(a, b, assertNotEquals(a uniqueId, b uniqueId, call message))
    assertNil     := method(a, assertEquals(a, nil, call message))
    assertNotNil  := method(a, assertNotEquals(a, nil, call message))
    assertTrue    := method(a, assertEquals(a, true, call message))
    assertFalse   := method(a, assertEquals(a, false, call message))

    assertRaisesException := method(
        exc := try(stopStatus(call evalArgAt(0)))
        exc ifNil(Exception raise("Should have raised Exception"))
    )

    knownBug := method(
        //writeln("  [known bug: ", call argAt(0) code, "]")
    )

    assertEqualsWithinDelta := method(expected, actual, delta,
        if(((expected - actual) abs > delta),
            Exception raise("expected " .. expected .. " but was " .. actual .. " (allowed delta: " .. delta .. ")")
        )
    )
)

//metadoc TestSuite category Testing
/*metadoc TestSuite description
An object to collect and run multiple UnitTests defined in *Test.io files within the System launchPath directory.
*/
TestSuite := TestRunner clone do(
    path ::= "."

//doc TestSuite with(aPath) Returns a new instance with the provided path.
    with := method(path, self clone setPath(path))

    testFiles := method(
        Directory with(System launchPath) files select(name endsWithSeq("Test.io"))
    )

    prepare := method(
        testFiles foreach(file,
            # Note: second argument is a label.
            Lobby doString(file contents, file path)
        )

        # Iterating over all of the imported objects and collecting
        # UnitTest instances. Since Block objects doesn't respond
        # correctly to isKindOf, we need to filter out all activatable
        # objects first and only then check for the type (kind).
        Lobby foreachSlot(slotName, slotValue,
            if (getSlot("slotValue") isActivatable not and \
                slotValue isKindOf(UnitTest),
                    slotValue prepare
                    self cases mergeInPlace(slotValue cases)
            )
        )
    )
)