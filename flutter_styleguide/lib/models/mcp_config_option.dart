/// Simple MCP Configuration option model for styleguide
class McpConfigOption {
  final String? id;
  final String name;
  final bool isNone;

  const McpConfigOption({required this.name, this.id, this.isNone = false});

  /// Create the "None" option (disables MCP)
  const McpConfigOption.none() : this(name: 'None', id: null, isNone: true);

  /// Create from existing configuration
  const McpConfigOption.fromConfig({required String id, required String name})
    : this(name: name, id: id, isNone: false);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is McpConfigOption && other.id == id && other.name == name && other.isNone == isNone;
  }

  @override
  int get hashCode => Object.hash(id, name, isNone);

  @override
  String toString() => 'McpConfigOption(id: $id, name: $name, isNone: $isNone)';
}
