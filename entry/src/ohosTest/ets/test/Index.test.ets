import { describe, expect, it, Level } from '@ohos/hypium';
import { abilityDelegatorRegistry, Driver, ON } from '@kit.TestKit';
import { UIAbility, Want } from '@kit.AbilityKit';

const delegator: abilityDelegatorRegistry.AbilityDelegator =
  abilityDelegatorRegistry.getAbilityDelegator();

async function startApp(driver: Driver): Promise<void> {
  const bundleName: string = abilityDelegatorRegistry.getArguments().bundleName;

  const want: Want = {
    bundleName: bundleName,
    abilityName: 'EntryAbility'
  };

  await delegator.startAbility(want);
  await driver.waitForIdle(4000, 5000);
}

export default function abilityTest() {
  describe('IndexAbilityTest', () => {
    it('shouldStartEntryAbility', Level.LEVEL3, async (done: Function) => {
      const driver: Driver = Driver.create();
      await startApp(driver);

      const ability: UIAbility = await delegator.getCurrentTopAbility();

      expect(ability.context.abilityInfo.name).assertEqual('EntryAbility');
      done();
    });

    it('shouldShowIndexTitleAndOption', Level.LEVEL3, async (done: Function) => {
      const driver: Driver = Driver.create();
      await startApp(driver);

      await driver.assertComponentExist(ON.text('BasketAnalyze'));
      await driver.assertComponentExist(ON.text('Shot Analysis'));

      done();
    });

    it('shouldNavigateToDetailsWhenOptionClicked', Level.LEVEL3, async (done: Function) => {
      const driver: Driver = Driver.create();
      await startApp(driver);

      const scrollComponent = await driver.findComponent(ON.scrollable(true));

      const passAnalysis = await scrollComponent.scrollSearch(ON.text('Pass Analysis'));
      await passAnalysis.click();

      await driver.waitForIdle(4000, 5000);
      await driver.assertComponentExist(ON.text('Pass Analysis'));
      await driver.pressBack();

      expect(true).assertTrue();

      done();
    });
  });
}