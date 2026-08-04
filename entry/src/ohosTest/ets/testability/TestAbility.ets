import { AbilityConstant, UIAbility, Want } from '@kit.AbilityKit';
import { abilityDelegatorRegistry } from '@kit.TestKit';
import { Hypium } from '@ohos/hypium';
import testsuite from '../test/List.test';
import { window } from '@kit.ArkUI';

const TAG = '[TestAbility]';

export default class TestAbility extends UIAbility {
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam) {
    console.info(`${TAG} onCreate() called.`);
    console.info(`${TAG} launchParam: ${JSON.stringify(launchParam)}`);

    // Retrieve the ability delegator and test arguments required to run the tests.
    const abilityDelegator = abilityDelegatorRegistry.getAbilityDelegator();
    const abilityDelegatorArguments = abilityDelegatorRegistry.getArguments();

    // Initialize and execute the custom test suite through Hypium.
    Hypium.hypiumTest(abilityDelegator, abilityDelegatorArguments, testsuite);
  }

  onDestroy() {
    console.info(`${TAG} onDestroy() called`);
  }

  onWindowStageCreate(windowStage: window.WindowStage) {
    console.info(`${TAG} onWindowStageCreate() called.`);

    // Load the custom Index page used as the entry point for the test application.
    windowStage.loadContent('testability/pages/Index', (err, data) => {
      if (err.code) {
        console.error(
          `${TAG} Failed to load the content. ${JSON.stringify(err) ?? ''}`
        );
        return;
      }

      console.info(
        `${TAG} Succeeded in loading the content. ${JSON.stringify(data) ?? ''}`
      );
    });
  }

  onWindowStageDestroy() {
    console.info(`${TAG} onWindowStageDestroy() called`);
  }

  onForeground() {
    console.info(`${TAG} onForeground() called`);
  }

  onBackground() {
    console.info(`${TAG} onBackground() called`);
  }
}