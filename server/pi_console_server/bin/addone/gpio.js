const wpi = require('wiring-pi');
wpi.wiringPiSetup();

const pinResetBT = 1;
wpi.pinMode(pinResetBT, wpi.OUTPUT);
wpi.digitalWrite(pinResetBT, 1);
function resetBT() {
	wpi.digitalWrite(pinResetBT, 0);
	setTimeout(() => {
		wpi.digitalWrite(pinResetBT, 1);
	}, 20);
};

module.exports = {
	resetBT: resetBT
}