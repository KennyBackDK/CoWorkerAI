// File: CoWorkerAI/CoWorkerAI/Services/AI/AIRouter.swift
import Foundation

/// Simple policy-based router stub. Later: route by task, size, budget, latency.
final class AIRouter {
    func pickModel(for role: String, tags: [String]) -> String {
        // Very naive policy for now – just a label
        if tags.contains(where: { $0.lowercased().contains("swift") }) {
            return "model:swift-coder"
        }
        if role.lowercased().contains("planner") {
            return "model:planner"
        }
        return "model:general"
    }
}

