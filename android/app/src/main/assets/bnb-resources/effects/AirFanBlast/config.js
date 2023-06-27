let isPlaying = true;
function Effect() {
	var self = this;

	/*
	this.meshes = [
		{ file:"fan.bsm2", anims:[
			{ a:"fan01", t:2966.67 },
			{ a:"fan02", t:3000 },
			{ a:"fan03", t:3000 },
		] },

	];
	*/

	this.play = function() {
		var now = (new Date()).getTime();
		if( now > self.t ) {
			Api.meshfxMsg("animOnce", 0, 0, "fan0" + (Math.floor(Math.random()*3)+1) );
			self.t = now + 3000;
		}
	};

	this.init = function() {
		Api.meshfxMsg("spawn", 0, 0, "fan.bsm2");
		self.t = 0;
		isPlaying && Api.playSound("AirFn_Blast_4.ogg", true, 1);
		self.faceActions = [self.play];
		Api.showRecordButton();
	};

	this.restart = function() {
		Api.meshfxReset();
		self.init();
	};

	this.faceActions = [];
	this.noFaceActions = [];

	this.videoRecordStartActions = [this.restart];
	this.videoRecordFinishActions = [];
	this.videoRecordDiscardActions = [this.restart];
}

configure(new Effect());

function stopMusic(){
	isPlaying = false;
	Api.stopSound("AirFn_Blast_4.ogg")
}