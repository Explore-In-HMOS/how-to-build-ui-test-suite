import { describe, it, expect, TestType, beforeEach } from '@ohos/hypium';
import { abilityDelegatorRegistry, Driver, ON, UIElementInfo, UIEventObserver } from '@kit.TestKit';
import { Want } from '@kit.AbilityKit';

// Provides access to the application lifecycle during instrument tests.
const delegator: abilityDelegatorRegistry.AbilityDelegator =
  abilityDelegatorRegistry.getAbilityDelegator();

let driver: Driver;
let appStarted: boolean = false;
let expectedScore: string = '';

// Starts the application and waits until the UI becomes idle.
async function startApp(driver: Driver): Promise<void> {
  const bundleName: string = abilityDelegatorRegistry.getArguments().bundleName;

  const want: Want = {
    bundleName: bundleName,
    abilityName: 'EntryAbility'
  };

  try {
    await delegator.startAbility(want);
    await driver.waitForIdle(4000, 5000);
  } catch (e) {
    console.error(`Error starting the app: ${e}`);
  }
}

// Returns to the home page before the next test begins.
async function resetToHome(driver: Driver): Promise<void> {
  try {
    await driver.pressBack();
    await driver.waitForIdle(500, 1000);
    await driver.pressBack();
    await driver.waitForIdle(500, 1000);
  } catch (e) {
    console.error(`Error reset to home page: ${e}`);
  }
}

// Opens Dribble Analysis, reads its score, and navigates to the Statics page.
async function navigateToStatics(driver: Driver): Promise<string> {
  try {
    const dribbleAnalysis = await driver.findComponent(ON.text('Dribble Analysis'));
    await dribbleAnalysis.click();

    // Save the score shown on the Details page for later comparison.
    const scoreLabel = await driver.findComponent(ON.id('detailsScoreLabel'));
    const expectedScore = await scoreLabel.getText();

    const buttonComponent = await driver.findComponent(ON.id('detailsAddButton'));
    await buttonComponent.click();
    await driver.waitForIdle(2000, 3000);

    return expectedScore;
  } catch (e) {
    console.error(`Error navigating to Statics page: ${e}`);
    return 'error_code404';
  }
}

export default function staticsAbilityTest() {
  describe('StaticsAbilityTest', () => {
    // Prepares the application and opens the Statics page before each test.
    beforeEach(async () => {
      try {
        driver = Driver.create();

        if (!appStarted) {
          // Start the application only once for the full test suite.
          await startApp(driver);
          appStarted = true;
        } else {
          // Later tests reuse the running app and return to the starting page.
          await resetToHome(driver);
        }

        expectedScore = await navigateToStatics(driver);
      } catch (e) {
        console.error(`Error inside beforeEach: ${e}`);
      }
    });

    // Confirms that refreshing the metrics displays the expected toast message.
    it('refreshButton_shouldEmitToast', TestType.FUNCTION, async (done: Function) => {
      try {
        const observer: UIEventObserver = driver.createUIEventObserver();
        let capturedText: string = '';
        let capturedBundle: string = '';

        // Capture the next toast event emitted by the application.
        const callback = (uiElementInfo: UIElementInfo) => {
          capturedText = uiElementInfo.text;
          capturedBundle = uiElementInfo.bundleName;

          console.info(`[StaticsTest] toastShow -> text: ${capturedText}, ` +
            `bundleName: ${capturedBundle}, type: ${uiElementInfo.type}`);
        };

        observer.once('toastShow', callback);

        // Pressing refresh should trigger the toast.
        const refreshBtn = await driver.findComponent(ON.id('refreshButton'));
        await refreshBtn.click();

        // Give the observer enough time to receive the toast event.
        await driver.delayMs(1500);

        expect(capturedText).assertEqual('Metrics refreshed');
        expect(capturedBundle.length > 0).assertTrue();

        done();
      } catch (e) {
        console.error(`Error on emitting toast message: ${e}`);
      }
    });

    // Checks that all main components on the Statics page are available.
    it('shouldShowAllStaticsComponents', TestType.FUNCTION, async (done: Function) => {
      try {
        // These components should be visible when the page first opens.
        await driver.assertComponentExist(ON.id('staticsScoreStack'));
        await driver.assertComponentExist(ON.id('staticsScoreRing'));
        await driver.assertComponentExist(ON.id('staticsScoreColumn'));
        await driver.assertComponentExist(ON.id('staticsScore'));
        await driver.assertComponentExist(ON.id('staticsScoreCaption'));
        await driver.assertComponentExist(ON.id('staticsTitleText'));
        await driver.assertComponentExist(ON.id('staticsStatusPill'));
        await driver.assertComponentExist(ON.id('refreshButton'));

        // Scroll down so the lower statistics sections become visible.
        const scrollComponent = await driver.findComponent(ON.scrollable(true));
        await scrollComponent.scrollToBottom();
        await driver.waitForIdle(500, 1000);

        await driver.assertComponentExist(ON.id('staticsMetricsColumn'));
        await driver.assertComponentExist(ON.id('staticsTrendColumn'));
        await driver.assertComponentExist(ON.id('staticsTrendLabel'));
        await driver.assertComponentExist(ON.id('staticsTrendRow'));
        await driver.assertComponentExist(ON.id('staticsLastUpdateText'));

        done();
      } catch (e) {
        console.error(`All components not present: ${e}`);
      }
    });

    // Verifies that the Statics page displays the score read from Details.
    it('scoreRing_shouldDisplayExpectedText', TestType.FUNCTION, async (done: Function) => {
      try {
        const scoreText = await driver.findComponent(ON.id('staticsScore'));
        const text = await scoreText.getText();

        expect(text).assertEqual(expectedScore);

        done();
      } catch (e) {
        console.error(`Score on Details page not match: ${e}`);
      }
    });
  });
}