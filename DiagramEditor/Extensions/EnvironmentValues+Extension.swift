import SwiftUICore

private struct DocumentKey: EnvironmentKey {
    static var defaultValue = DiagramDocument()
}

extension EnvironmentValues {
    var document: DiagramDocument {
        get { self[DocumentKey.self] }
        set { self[DocumentKey.self] = newValue }
    }
}
