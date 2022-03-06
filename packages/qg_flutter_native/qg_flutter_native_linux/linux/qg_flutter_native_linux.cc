#include "include/qg_flutter_native/qg_flutter_native_linux.h"

#include <flutter_linux/flutter_linux.h>
#include <gtk/gtk.h>
#include <sys/utsname.h>

#include <cstring>

#define QG_FLUTTER_NATIVE_LINUX_PLATFORM(obj) \
  (G_TYPE_CHECK_INSTANCE_CAST((obj), qg_flutter_native_linux_get_type(), \
                              QgFlutterNativeLinuxPlatform))

struct _QgFlutterNativeLinuxPlatform {
  GObject parent_instance;
};

G_DEFINE_TYPE(QgFlutterNativeLinuxPlatform, qg_flutter_native_linux, g_object_get_type())

// Called when a method call is received from Flutter.
static void qg_flutter_native_linux_handle_method_call(
    QgFlutterNativeLinuxPlatform* self,
    FlMethodCall* method_call) {
  g_autoptr(FlMethodResponse) response = nullptr;

  const gchar* method = fl_method_call_get_name(method_call);

  if (strcmp(method, "getPlatformVersion") == 0) {
    struct utsname uname_data = {};
    uname(&uname_data);
    g_autofree gchar *version = g_strdup_printf("Linux %s", uname_data.version);
    g_autoptr(FlValue) result = fl_value_new_string(version);
    response = FL_METHOD_RESPONSE(fl_method_success_response_new(result));
  } else {
    response = FL_METHOD_RESPONSE(fl_method_not_implemented_response_new());
  }

  fl_method_call_respond(method_call, response, nullptr);
}

static void qg_flutter_native_linux_dispose(GObject* object) {
  G_OBJECT_CLASS(qg_flutter_native_linux_parent_class)->dispose(object);
}

static void qg_flutter_native_linux_class_init(QgFlutterNativeLinuxPlatform* klass) {
  G_OBJECT_CLASS(klass)->dispose = qg_flutter_native_linux_dispose;
}

static void qg_flutter_native_linux_init(QgFlutterNativeLinuxPlatform* self) {}

static void method_call_cb(FlMethodChannel* channel, FlMethodCall* method_call,
                           gpointer user_data) {
  QgFlutterNativeLinuxPlatform* plugin = QG_FLUTTER_NATIVE_LINUX_PLATFORM(user_data);
  qg_flutter_native_linux_handle_method_call(plugin, method_call);
}

void qg_flutter_native_linux_register_with_registrar(FlPluginRegistrar* registrar) {
  QgFlutterNativeLinuxPlatform* plugin = QG_FLUTTER_NATIVE_LINUX_PLATFORM(
      g_object_new(qg_flutter_native_linux_get_type(), nullptr));

  g_autoptr(FlStandardMethodCodec) codec = fl_standard_method_codec_new();
  g_autoptr(FlMethodChannel) channel =
      fl_method_channel_new(fl_plugin_registrar_get_messenger(registrar),
                            "qg_flutter_native",
                            FL_METHOD_CODEC(codec));
  fl_method_channel_set_method_call_handler(channel, method_call_cb,
                                            g_object_ref(plugin),
                                            g_object_unref);

  g_object_unref(plugin);
}
