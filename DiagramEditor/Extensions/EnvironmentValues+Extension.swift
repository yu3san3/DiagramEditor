import SwiftUICore

private struct DocumentKey: EnvironmentKey {
    static var defaultValue = DiagramEditorDocument()
}

extension EnvironmentValues {
    var document: DiagramEditorDocument {
        get { self[DocumentKey.self] }
        set { self[DocumentKey.self] = newValue }
    }
}
