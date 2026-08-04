import { abilityDelegatorRegistry, TestRunner } from '@kit.TestKit';

const TAG = '[OpenHarmonyTestRunner]';

let abilityDelegator: abilityDelegatorRegistry.AbilityDelegator | undefined = undefined;
let abilityDelegatorArguments: abilityDelegatorRegistry.AbilityDelegatorArgs | undefined = undefined;

async function onAbilityCreateCallback() {
  console.info(`${TAG} custom onAbilityCreateCallback() called.`);
}

async function addAbilityMonitorCallback(err: Error) {
  console.info(
    `${TAG} custom addAbilityMonitorCallback() called. ${JSON.stringify(err) ?? '[no error]'}`
  );
}

export default class OpenHarmonyTestRunner implements TestRunner {
  constructor() {}

  onPrepare() {
    console.info(`${TAG} onPrepare() called.`);
  }

  async onRun() {
    console.info(`${TAG} onRun() called.`);

    abilityDelegatorArguments = abilityDelegatorRegistry.getArguments();
    abilityDelegator = abilityDelegatorRegistry.getAbilityDelegator();

    let testAbilityName = `${abilityDelegatorArguments.bundleName}.TestAbility`;

    let lMonitor: abilityDelegatorRegistry.AbilityMonitor = {
      abilityName: testAbilityName,
      onAbilityCreate: onAbilityCreateCallback
    };

    abilityDelegator.addAbilityMonitor(lMonitor, addAbilityMonitorCallback);

    let cmd = `aa start -d 0 -a TestAbility -b ${abilityDelegatorArguments.bundleName}`;
    let debug = abilityDelegatorArguments.parameters['-D'];

    if (debug === 'true') {
      cmd += ' -D';
    }

    // You need to start your TestAbility from OpenHarmonyTestRunner
    abilityDelegator.executeShellCommand(cmd, (err, data) => {
      console.info(
        `${TAG} executeShellCommand() called with err: ${JSON.stringify(err) ?? '[no error]'}`
      );
      console.info(
        `${TAG} executeShellCommand() called with data: ${JSON.stringify(data) ?? '[no data]'}`
      );
    });
  }
}