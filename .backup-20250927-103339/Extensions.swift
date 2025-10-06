// File: CoWorkerAI/CoWorkerAI/Utilities/Extensions.swift
import Foundation

extension Set {
    /// Returns true if the two sets have no elements in common.
    func isDisjoint(with other: Set<Element>) -> Bool where Element: Hashable {
        return self.intersection(other).isEmpty
    }
}
