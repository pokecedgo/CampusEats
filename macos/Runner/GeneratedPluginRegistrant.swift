import FlutterMacOS
import Foundation

func RegisterGeneratedPlugins(registry: FlutterPluginRegistry) {
    FLTFirebaseAuthPlugin.register(with: registry.registrar(forPlugin: "FLTFirebaseAuthPlugin"))
    FLTFirebaseCorePlugin.register(with: registry.registrar(forPlugin: "FLTFirebaseCorePlugin"))
    // Remove any window_size related registrations if present
}
