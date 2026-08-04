import { describe, it, expect } from '@ohos/hypium'
import { Driver, ON } from '@ohos.UiTest'
import abilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry'

const delegator = abilityDelegatorRegistry.getAbilityDelegator()
const bundleName = abilityDelegatorRegistry.getArguments().bundleName

// This test targets the custom `testability/pages/Index.ets` page.
// To run tests specific to this test page, call `delegator.startAbility`
// with `abilityName` set to `'TestAbility'`.

export default function testabilityPageTest() {
  describe('TestabilityPageTest', () => {
    it('shouldShowExamplePageTitleAndSubtitle', 0, async (done: Function) => {
      // Launch the TestAbility, which loads testability/pages/Index.ets
      try {
        await delegator.startAbility({
          bundleName: bundleName,
          abilityName: 'TestAbility'
        });

        const driver = Driver.create();
        await driver.delayMs(1000);

        const title = await driver.findComponent(ON.text('Example Page'));
        expect(title !== null).assertTrue();
        expect(await title.getText()).assertEqual('Example Page');

        const subtitle = await driver.findComponent(
          ON.text(
            'This is an example page where you can configure your custom tests with custom test pages in your testability/pages/Index.ets')
        );
        expect(subtitle !== null).assertTrue();

        done()
      } catch (e) {
        console.info(`Error while testing TestAbility: ${JSON.stringify(e)}`);
      }
    })

  })
}