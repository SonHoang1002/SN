function Effect()
{
    var self = this;

    this.init = function() {
        Api.meshfxMsg("spawn", 0, 0, "tri2.bsm2");
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