ListTest := UnitTest clone do(
	setUp := method(
		super(setUp)
		self exampleList := List clone append("a", "beta", 3)
	)

	testClone := method(
		assertNotSame(List, List clone)
		clonedList := exampleList clone
		assertNotSame(clonedList, exampleList)
		assertEquals(3, clonedList size)
		assertEquals(exampleList at(0), clonedList at(0))
		assertEquals(exampleList at(2), clonedList at(2))
	)

	testAppend := method(
		assertRaisesException(a append)
		a := exampleList
		a append(nil)
		a append(88)
		a append("blah", "fasel")
		assertEquals("fasel", a at(6))
		assertEquals(88, a at(4))
		assertNil(a at(3))
	)

	testAppendIfAbsent := method(
		a := exampleList
		a appendIfAbsent
		a appendIfAbsent(nil)
		a appendIfAbsent(3)
		a appendIfAbsent(3)
		assertEquals(4, a size)
		assertNil(a at(3))
		a appendIfAbsent("blah", "blah", 3, "new1", "blah", "new2")
		assertEquals(7, a size)
		assertEquals("blah", a at(4))
		assertEquals("new1", a at(5))
		assertEquals("new2", a at(6))
	)

	testAppendSeq := method(
		a := exampleList
		assertRaisesException(a appendSeq(nil))
		assertRaisesException(a appendSeq(a))
		a appendSeq(List clone)
		a appendSeq(List clone append("blah", "fasel"))
		assertEquals(5, a size)
		assertEquals("blah", a at(3))
		assertEquals("fasel", a at(4))
	)

	testRemove := method(
		a := exampleList
		assertRaisesException(a remove)
		a append(nil, 7, nil)
		a remove(nil)
		assertEquals(4, a size)
		a remove(3)
		assertEquals(3, a size)
		assertEquals("a", a at(0))
		assertEquals("beta", a at(1))
		assertEquals(7, a at(2))
	)

	testIndexOf := method(
		a := exampleList
		assertRaisesException(a indexOf)
		assertNil(a indexOf(nil))
		a append("a")
		assertEquals(0, a indexOf("a"))
		a removeAt(0)
		assertEquals(2, a indexOf("a"))
	)

	testContains := method(
		a := exampleList
		assertFalse(a contains)
		assertFalse(a contains(nil))
		assertFalse(a contains(333))
		assertTrue(a contains("beta"))
	)

	testPush := method(
		a := exampleList
		assertRaisesException(a push)
		a push(nil)
		a push(88)
		a push("blah", "fasel")
		assertEquals("fasel", a at(6))
		assertEquals(88, a at(4))
		assertNil(a at(3))
	)

	testPop := method(
		a := exampleList
		assertEquals(3, a pop)
		assertEquals(2, a size)
		assertEquals("beta", a pop)
		assertEquals(1, a size)
		assertEquals("a", a pop)
		assertEquals(0, a size)
		assertNil(a pop)
	)

	testEmpty := method(
		a := exampleList
		a empty
		assertEquals(0, a size)
	)

	testsize := method(
		a := exampleList
		assertEquals(0, List size)
		assertEquals(3, a size)
		a append("yo")
		assertEquals(4, a size)
	)

	testAtInsert := method(
		a := exampleList
		assertRaisesException(a atInsert())
		assertRaisesException(a atInsert(nil))
		assertRaisesException(a atInsert(nil, "two"))
		assertRaisesException(a atInsert(-1, "two"))
		assertRaisesException(a atInsert(4, "two"))

		a atInsert(0, "zero")
		assertEquals(4, a size)
		assertEquals(0, a indexOf("zero"))

		a atInsert(1, "one")
		assertEquals(5, a size)
		assertEquals(1, a indexOf("one"))

		a atInsert(5, "append")
		assertEquals(6, a size)
		assertEquals(5, a indexOf("append"))
	)

	testRemoveAt := method(
		a := exampleList
		assertRaisesException(a removeAt())
		assertRaisesException(a removeAt(nil))
		assertRaisesException(a removeAt(-1))
		assertRaisesException(a removeAt(3))

		a removeAt(0)
		assertEquals(2, a size)
		assertEquals("beta", a at(0))
		assertEquals(3, a at(1))

		a removeAt(1)
		assertEquals(1, a size)
		assertEquals("beta", a at(0))
	)

	testAt := method(
		a := exampleList
		assertRaisesException(a at())
		assertRaisesException(a at(nil))
        # Checkinng that negative indexing actually works.
		assertNotNil(a at(-1))
        assertEquals(3, a at(-1))
        assertEquals("a", a at(-3))
        assertNil(a at(-4)) # index out off bounds
		assertNil(a at(4))
		assertEquals("a", a at(0))
		assertEquals("beta", a at(1))
		assertEquals(3, a at(2))
	)

	testAtPut := method(
		a := exampleList
		assertRaisesException(a atPut())
		assertRaisesException(a atPut(nil))
		assertRaisesException(a atPut(nil, "two"))
		assertRaisesException(a atPut(-1, "two"))
		assertRaisesException(a atPut(3, "two"))

		a atPut(0, "zero")
		assertEquals(3, a size)
		assertEquals(0, a indexOf("zero"))

		a atPut(2, "two")
		assertEquals(3, a size)
		assertEquals(2, a indexOf("two"))
	)

	testSwapIndices := method(
		a := exampleList
		assertRaisesException(a swapIndices())
		assertRaisesException(a swapIndices(nil))
		assertRaisesException(a swapIndices(nil, nil))
		assertRaisesException(a swapIndices(1, nil))
		assertRaisesException(a swapIndices(nil, 1))
		assertRaisesException(a swapIndices(0, 3))
		assertRaisesException(a swapIndices(-1, 2))

		a swapIndices(0, 2)
		a swapIndices(1, 1)
		assertEquals("a", a at(2))
		assertEquals("beta", a at(1))
		assertEquals(3, a at(0))
	)

	testpreallocateToSize := method(
		a := exampleList
		assertRaisesException(a preallocateToSize)
		assertRaisesException(a preallocateToSize(nil))
		a preallocateToSize(1)
		assertEquals(3, a size)
		a preallocateToSize(10)
		assertEquals(3, a size)
	)

	testFirst := method(
		a := exampleList
		assertNil(List first)
		assertEquals("a", a first)
	)

	testLast := method(
		a := exampleList
		assertNil(List last)
		assertEquals(3, a last)
	)

	_testPrint := method(
		// would need to be able to read stdout or install a printCallback from Io to test print()
		Nop
	)

	testSelect := method(
		a := exampleList
		assertRaisesException(a select)
		selection := a select(index, value, index == 0 or value == 3)
		assertEquals(2, selection size)
		assertEquals("a", selection at(0))
		assertEquals(3, selection at(1))

		selection := a select(index, value, index == -1)
		assertEquals(0, selection size)
	)

	testSelect2 := method(
		a := exampleList
		assertRaisesException(a select)
		selection := a select(value, value == "a" or value == 3)
		assertEquals(2, selection size)
		assertEquals("a", selection at(0))
		assertEquals(3, selection at(1))

		selection := a select(index, value, index == -1)
		assertEquals(0, selection size)
	)

	testSelectInPlace := method(
		a := exampleList
		assertRaisesException(a selectInPlace)
		a selectInPlace(index, value, index == 0 or value == 3)
		assertEquals(2, a size)
		assertEquals("a", a at(0))
		assertEquals(3, a at(1))

		a selectInPlace(index, value, index == -1)
		assertEquals(0, a size)
	)

	testSelectInPlace2 := method(
		a := exampleList
		a selectInPlace(index, value, value == "a" or value == 3)
		assertEquals(2, a size)
		assertEquals("a", a at(0))
		assertEquals(3, a at(1))

		a selectInPlace(index, value, index == -1)
		assertEquals(0, a size)
	)

	testDetect := method(
		a := exampleList
		assertRaisesException(a detect)
		assertRaisesException(a detect(nil))
		a detect(index, value, index == 0 or value == 3)
		assertEquals("a", a detect(index, value, index == 0 or value == 3))
		assertEquals(3, a detect(index, value, value type == "Number" and value > 1))
		assertNil(a detect(index, value, value > 3))
	)

	testDetect := method(
		a := exampleList
		assertRaisesException(a detect)
		a detect(index, value, value = "a" or value == 3)
		assertEquals("a", a detect(index, value, index == 0 or value == 3))
		assertEquals(3, a detect(index, value, value type == "Number" and value > 1))
		assertNil(a detect(index, value, value type == "Number" and value > 3))
	)

	testSort := method(
		a := List clone append("a", "beta", "3")
		List clone sortInPlace
		a sortInPlace
		assertEquals("3", a at(0))
		assertEquals("a", a at(1))
		assertEquals("beta", a at(2))

		a append("0") sortInPlace
		assertEquals("0", a at(0))
		assertEquals("3", a at(1))
		assertEquals("a", a at(2))
		assertEquals("beta", a at(3))
	)

	testSortBy := method(
		a := List clone append("beta", "3", "alpha")
		assertRaisesException(a sortInPlaceBy)
		assertRaisesException(a sortInPlaceBy(nil))
		a sortInPlaceBy(block(v1, v2, v1 < v2))
		assertEquals("3", a at(0))
		assertEquals("alpha", a at(1))
		assertEquals("beta", a at(2))
	)

	testEmptyListSortBy := method(
		assertEquals(List clone sortInPlaceBy(block(x, y, x < y)), List clone)
	)

	testSortBySingleItem := method(
		assertEquals(list(3) sortInPlaceBy(block(x, y, x < y)), list(3))
	)

	testSortByTwoItems := method(
		assertEquals(list(3,1) sortInPlaceBy(block(x, y, x < y)), list(1,3))
	)

	testForeach := method(
		a := exampleList
		assertRaisesException(a foreach)
		string := ""
		assertEquals("abeta3", a foreach(index, value, string := string .. value asString))

		string := ""
		assertEquals("abeta3", a foreach(value, string := string .. value asString))

		number := 0
		assertEquals(0+1+2, a foreach(index, value, number := number + index))
	)

	testReverse := method(
		a := exampleList
		reversedA := a reverse
		assertEquals(3, reversedA at(0))
		assertEquals("beta", reversedA at(1))
		assertEquals("a", reversedA at(2))
	)

	testReverseForeach := method(
		a := exampleList
		assertRaisesException(a reverseForeach)
		assertRaisesException(a reverseForeach(nil))
		string := ""
		assertEquals("3betaa", a reverseForeach(index, value, string := string .. value asString))

		string := ""
		assertEquals("3betaa", a reverseForeach(value, string := string .. value asString))

		number := 0
		assertEquals(0+1+2, a reverseForeach(index, value, number := number + index))
	)

	testmap := method(
		a := exampleList
		assertRaisesException(a map)
		a mapInPlace(index, value, value asString .. index asString)
		assertEquals(3, a size)
		assertEquals("a0", a at(0))
		assertEquals("beta1", a at(1))
		assertEquals("32", a at(2))
	)

	testmap2 := method(
		a := exampleList
		a mapInPlace(value, value asString)
		assertEquals(3, a size)
		assertEquals("a", a at(0))
		assertEquals("beta", a at(1))
		assertEquals("3", a at(2))
	)

	testMap := method(
		a := exampleList
		assertRaisesException(a map)
		assertRaisesException(a mapInPlace)
		a mapInPlace(index, value, value asString .. index asString)
		assertEquals(3, a size)
		assertEquals("a0", a at(0))
		assertEquals("beta1", a at(1))
		assertEquals("32", a at(2))
	)

	testMap2 := method(
		a := exampleList
		a mapInPlace(value, value asString)
		assertEquals(3, a size)
		assertEquals("a", a at(0))
		assertEquals("beta", a at(1))
		assertEquals("3", a at(2))
	)

	testAsMap := method(
		l := list(list("d", 4), list("c", 3), list("a", 1), list("b", 2))
		m := l asMap

		assertEquals(4, m size)

		l foreach(pair,
			key := pair at(0)
			value := pair at(1)

			assertTrue(m hasKey(key))
			assertEquals(value, m at(key))

			m removeAt(key)
		)

		assertEquals(0, m size)
	)

	testEncodedList := method(
		t := list(123)
		assertEquals(t, t asEncodedList asDecodedList)
		t := list(1, 2, 3)
		assertEquals(t, t asEncodedList asDecodedList)
		t := list(1, "test", nil, "foo", 3)
		assertEquals(t, t asEncodedList asDecodedList)
		t := list("foo")
		assertEquals(t, t asEncodedList asDecodedList)
	)

    testSlice := method(
        a := list(1, 2, 3, 4, 5, 6)
        assertEquals(a, a slice(0))
        assertEquals(a, a slice(0, a size))
        assertNil(
            try(assertEquals(a, a slice(0, a size * 2))),
            "No Exception should've been raised")

        # Testing the case, where there's no upper border,
        # expecting it to be List size.
        assertEquals(a slice(2, a size), a slice(2))
        assertEquals(list(3, 4, 5, 6), a slice(2))

        # Testing negative indexing.
        assertEquals(list(1, 2, 3, 4, 5), a slice(0, -1))
        assertEquals(list(1, 2, 3), a slice(0, -3))
        assertEquals(list(), a slice(0, -(a size)))

        # Testing step in action.
        assertEquals(a, a slice(0, a size, 1))
        assertEquals(list(1, 3, 5), a slice(0, a size, 2))
        assertEquals(list(1, 4), a slice(0, a size, 3))
        assertEquals(list(1), a slice(0, a size, a size))

        # Note: The following should be probably hidden
        # behind syntactic sugar, like in Python:
        # >>> l = [1, 2, 3]
        # >>> l[::-1] == l[-1, - (len(l) + 1), -1]
        assertEquals(a reverse, a slice(-1, - (a size + 1), -1))
        assertEquals(list(6, 4, 2), a slice(-1, - (a size + 1), -2))
        assertEquals(list(6, 3), a slice(-1, - (a size + 1), -3))
        assertEquals(list(6), a slice(-1, - (a size + 1), - a size))

        # Finally, testing that a is unchanged :) too late?
        assertEquals(list(1, 2, 3, 4, 5, 6), a)
    )

    testSliceInPlace := method(
        # We don't have to test all the slice cases, just the
        # fact, that slicing is done in place both with positive
        # and negative indexing.
        a := exampleList clone
        a sliceInPlace(-1, - (a size + 1), -1)
        assertEquals(exampleList reverse, a)

        a := list(1, 2, 3, 4, 5, 6)
        a sliceInPlace(0, a size, 2)
        assertEquals(list(1, 3, 5), a)
    )

    testSum := method(
        assertEquals(6, list(1, 2, 3) sum)
        assertNil(list() sum)
    )

    testReduce := method(
        a := list(1, 2, 3)
        assertEquals(6, a reduce(+))
        assertEquals(6, a reduce(x, y, x + y))
        assertEquals(0, a reduce(+, -6))
        assertEquals(0, a reduce(x, y, x + y, -6))
    )

    testReverseReduce := method(
        a := list(1, 2, 3)
        assertEquals(6, a reverseReduce(+))
        assertEquals(6, a reverseReduce(x, y, x + y))
        assertEquals(0, a reverseReduce(+, -6))
        assertEquals(0, a reverseReduce(x, y, x + y, -6))

        # Now checking if the list is actually folded starting
        # from the right.
        assertEquals(0, a reverseReduce(-))
    )

    testJoin := method(
        a := list(1, 2, 3)
        assertEquals("123", a join)
        assertEquals("1, 2, 3", a join(", "))
        assertEquals("1", list(1) join(", "))
        assertEquals("", list() join(", "))
    )

    testAsString := method(
        assertEquals("list(1, 2, 3)", list(1, 2, 3) asString)
        assertEquals("list()", list() asString)
    )
)

if(isLaunchScript, ListTest run, ListTest)