#import "QgFlutterNativePlugin.h"
#if __has_include(<qg_flutter_native/qg_flutter_native-Swift.h>)
#import <qg_flutter_native/qg_flutter_native-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "qg_flutter_native-Swift.h"
#endif

@implementation QgFlutterNativePlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftQgFlutterNativePlugin registerWithRegistrar:registrar];
}
@end
