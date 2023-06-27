function Effect()
{
    var self = this;

    this.init = function() {
        Api.meshfxMsg("spawn", 3, 0, "quad_noize.bsm2");
        Api.meshfxMsg("shaderVec4", 0, 1, "10. 0 0 0");
        Api.meshfxMsg("spawn", 1, 0, "tri1.bsm2");
        Api.meshfxMsg("tex", 1, 0, "LUT_4.png");
        Api.meshfxMsg("spawn", 14, 0, "quad_tex4.bsm2");
    };

    this.restart = function() {
        Api.meshfxReset();
        self.init();
    };

    this.faceActions = [];
    this.noFaceActions = [];

    this.videoRecordStartActions = [];
    this.videoRecordFinishActions = [];
    this.videoRecordDiscardActions = [];
}

configure(new Effect());