struct ZipLongestSequence<Sequence1: Sequence, Sequence2: Sequence>: Sequence, IteratorProtocol {
    private var sequence1Iterator: Sequence1.Iterator
    private var sequence2Iterator: Sequence2.Iterator

    init(_ sequence1: Sequence1, _ sequence2: Sequence2) {
        self.sequence1Iterator = sequence1.makeIterator()
        self.sequence2Iterator = sequence2.makeIterator()
    }

    mutating func next() -> (Sequence1.Element?, Sequence2.Element?)? {
        let sequence1Value = sequence1Iterator.next()
        let sequence2Value = sequence2Iterator.next()
        return (sequence1Value == nil && sequence2Value == nil) ? nil : (sequence1Value, sequence2Value)
    }
}

extension Sequence {
    func zipLongest<S: Sequence>(_ other: S) -> ZipLongestSequence<Self, S> {
        ZipLongestSequence(self, other)
    }
}
