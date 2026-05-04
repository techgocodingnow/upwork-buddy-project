import Foundation

#if DEBUG
/// Dev-only schema introspection helper. Fire from a debug build to confirm field names
/// before baking them into Queries.swift.
///
/// Usage:
///   `swift run UpworkBuddy --introspect Contract,TimeReportFilter`
enum Introspection {
    static func dump(typeNames: [String]) async {
        for name in typeNames {
            do {
                let result = try await GraphQLClient.shared.execute(
                    query: Queries.introspectType,
                    variables: ["name": .string(name)],
                    as: Resp.self
                )
                if let type = result.__type {
                    print("==== \(type.name ?? name) (\(type.kind ?? "?")) ====")
                    for field in type.fields ?? [] {
                        let typeStr = field.type.map(typeDescription) ?? "?"
                        print("  • \(field.name): \(typeStr)")
                    }
                } else {
                    print("==== \(name): not found ====")
                }
            } catch {
                print("==== \(name): error \(error.localizedDescription) ====")
            }
        }
    }

    private static func typeDescription(_ t: TypeRef) -> String {
        switch t.kind {
        case "NON_NULL": return (t.ofType.map(typeDescription) ?? "?") + "!"
        case "LIST":     return "[" + (t.ofType.map(typeDescription) ?? "?") + "]"
        default:         return t.name ?? t.kind ?? "?"
        }
    }

    private struct Resp: Decodable, Sendable {
        let __type: TypeShape?
    }

    private struct TypeShape: Decodable, Sendable {
        let name: String?
        let kind: String?
        let fields: [Field]?
    }

    private struct Field: Decodable, Sendable {
        let name: String
        let type: TypeRef?
    }

    /// Class so the type can recursively contain itself.
    private final class TypeRef: Decodable, Sendable {
        let name: String?
        let kind: String?
        let ofType: TypeRef?
    }
}
#endif
