import { describe, expect, it, Level, beforeEach } from '@ohos/hypium';
import { abilityDelegatorRegistry, Driver, ON } from '@kit.TestKit';
import { Want } from '@kit.AbilityKit';

const delegator: abilityDelegatorRegistry.AbilityDelegator =
  abilityDelegatorRegistry.getAbilityDelegator();

let driver: Driver;
let appStarted: boolean = false;

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

async function resetToHome(driver: Driver): Promise<void> {
  try {
    await driver.pressBack();
    await driver.waitForIdle(500, 1000);
  } catch (e) {
    console.error(`Error reset to home page: ${e}`);
  }
}

async function navigateToDetails(driver: Driver): Promise<void> {
  try {
    const scrollComponent = await driver.findComponent(ON.scrollable(true));
    const dribbleAnalysis = await scrollComponent.scrollSearch(ON.text('Dribble Analysis'));

    await dribbleAnalysis.click();
    await driver.waitForIdle(2000, 3000);
  } catch (e) {
    console.error(`Error navigating to Details page: ${e}`);
  }
}

export default function detailsAbilityTest() {
  describe('DetailsAbilityTest', () => {

    beforeEach(async () => {
      try {
        driver = Driver.create();

        if (!appStarted) {
          await startApp(driver);
          appStarted = true;
        } else {
          await resetToHome(driver);
        }

        await navigateToDetails(driver);
      } catch (e) {
        console.error(`Error inside beforeEach: ${e}`);
      }
    });

    it('shouldShowDetailsScreenElements', Level.LEVEL3, async (done: Function) => {
      try {
        await driver.assertComponentExist(ON.id('detailsBackButton'));
        await driver.assertComponentExist(ON.id('detailsAddButton'));
        await driver.assertComponentExist(ON.id('detailsScoreLabel'));

        done();
      } catch (e) {
        console.error(`Details screen elements not present: ${e}`);
      }
    });

    it('shouldShowAllDetailsComponents', Level.LEVEL3, async (done: Function) => {
      try {
        await driver.assertComponentExist(ON.id('detailsColumn'));
        await driver.assertComponentExist(ON.id('detailsTitleText'));
        await driver.assertComponentExist(ON.id('detailsSubtitleText'));
        await driver.assertComponentExist(ON.id('detailsScoreRow'));
        await driver.assertComponentExist(ON.id('detailsBackButton'));
        await driver.assertComponentExist(ON.id('detailsBackIcon'));
        await driver.assertComponentExist(ON.id('detailsScoreLabel'));
        await driver.assertComponentExist(ON.id('detailsAddButton'));
        await driver.assertComponentExist(ON.id('detailsAddIcon'));
        await driver.assertComponentExist(ON.id('detailsStatusPill'));
        await driver.assertComponentExist(ON.id('detailsLastUpdateText'));

        done();
      } catch (e) {
        console.error(`All details components not present: ${e}`);
      }
    });

    it('shouldNavigateToStaticsWhenAddButtonClicked', Level.LEVEL3, async (done: Function) => {
      try {
        const addButton = await driver.findComponent(ON.id('detailsAddButton'));
        await addButton.click();

        await driver.waitForIdle(2000, 3000);

        const onStaticsScreen = await driver.findComponent(ON.id('staticsScreenRoot'));
        expect(onStaticsScreen !== null).assertTrue();

        done();
      } catch (e) {
        console.error(`Error navigating to Statics page from Details page: ${e}`);
      }
    });
  });
}