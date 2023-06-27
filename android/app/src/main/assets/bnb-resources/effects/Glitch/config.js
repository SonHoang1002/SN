function Effect()
{
    var self = this;
    var c = 0.5;
	var sec = 0;
	var lastFrame;
	this.play = function() {
		var now = (new Date()).getTime();
		sec += (now - lastFrame)/1000;
		Api.meshfxMsg("shaderVec4", 0, 0, String(sec));
		//Api.showHint(String(sec));
		lastFrame = now;
	}

    this.init = function() {
        Api.meshfxMsg("spawn", 0, 0, "!glfx_FACE");
        Api.meshfxMsg("spawn", 1, 0, "tri1.bsm2");
        Api.meshfxMsg("tex", 1, 0, "glitch.png");
        Api.meshfxMsg("spawn", 4, 0, "tri.bsm2");

		lastFrame = (new Date()).getTime();
    };

    this.restart = function() {
        Api.meshfxReset();
        self.init();
    };
    
    this.faceActions = [self.play];
    this.noFaceActions = [];

    this.videoRecordStartActions = [this.delHint];
    this.videoRecordFinishActions = [];
    this.videoRecordDiscardActions = [];
}

configure(new Effect());