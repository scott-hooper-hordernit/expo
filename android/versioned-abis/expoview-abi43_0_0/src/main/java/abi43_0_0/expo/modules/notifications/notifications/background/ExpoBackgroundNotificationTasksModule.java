package abi43_0_0.expo.modules.notifications.notifications.background;

import android.content.Context;

import abi43_0_0.expo.modules.core.ExportedModule;
import abi43_0_0.expo.modules.core.ModuleRegistry;
import abi43_0_0.expo.modules.core.Promise;
import abi43_0_0.expo.modules.core.interfaces.ExpoMethod;
import org.unimodules.interfaces.taskManager.TaskManagerInterface;

import java.util.Collections;

public class ExpoBackgroundNotificationTasksModule extends ExportedModule {
  private TaskManagerInterface mTaskManager;

  public ExpoBackgroundNotificationTasksModule(Context context) {
    super(context);
  }

  @Override
  public String getName() {
    return "ExpoBackgroundNotificationTasksModule";
  }

  @Override
  public void onCreate(ModuleRegistry moduleRegistry) {
    mTaskManager = moduleRegistry.getModule(TaskManagerInterface.class);
  }

  @ExpoMethod
  public void registerTaskAsync(String taskName, final Promise promise) {
    try {
      mTaskManager.registerTask(
          taskName, BackgroundRemoteNotificationTaskConsumer.class, Collections.emptyMap());
      promise.resolve(null);
    } catch (Exception e) {
      promise.reject(e);
    }
  }

  @ExpoMethod
  public void unregisterTaskAsync(String taskName, final Promise promise) {
    try {
      mTaskManager.unregisterTask(taskName, BackgroundRemoteNotificationTaskConsumer.class);
      promise.resolve(null);
    } catch (Exception e) {
      promise.reject(e);
    }
  }
}
