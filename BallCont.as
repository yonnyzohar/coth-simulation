package {
	import flash.events.EventDispatcher;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.display.MovieClip;

	public class BallCont extends MovieClip {
		private var radian: Number;
		public var mouseDown: Boolean = false;
		public var myTarget: MovieClip;
		public var row: int;
		public var col: int;
		public var xOffest: int;
		public var yOffset: int;


		public function BallCont() {


		}

		public function update(): void {
			if (this.mouseDown) {
				this.x = this.stage.mouseX;
				this.y = this.stage.mouseY;
			} else {
				if (myTarget != null) {
					var yDistance: Number = (myTarget.y + this.yOffset) - this.y;
					var xDistance: Number = (myTarget.x + this.xOffest) - this.x;
					var distance: Number = Math.sqrt(yDistance * yDistance + xDistance * xDistance);
					var bb: Block;

					for (var _row: int = -1; _row <= 1; _row++) {
						for (var _col: int = -1; _col <= 1; _col++) {

							if (_row == 0 && _col == 0) {
								continue;
							}

							if (Main.net[this.row + _row] && Main.net[this.row + _row][this.col + _col]) {
								bb = Main.net[this.row + _row][this.col + _col];
								Main.mainMC.graphics.moveTo(this.x, this.y);
								Main.mainMC.graphics.lineTo(bb.x, bb.y);
							}
						}
					}

					radian = Math.atan2(yDistance, xDistance);
					var moveX: Number = Math.cos(radian) * (distance / 7);
					var moveY: Number = Math.sin(radian) * (distance / 7);
					var newX: Number = this.x + moveX;
					var newY: Number = this.y + moveY;

					this.x = newX;
					this.y = newY;



					//if (distance >= (speed ))//* (10 * Math.random())
					//{

					/*
						var touching:Boolean = false;
						outer :for ( _row = 0; _row < Main.net.length; _row++) {
							for ( _col = 0; _col < Main.net.length; _col++) {
								if(_row == this.row && _col == this.col)
								{
									continue;
								}
								var b:Block = Main.net[_row][_col];
								var distToBlock:Number = Math.sqrt((b.y - newY) * (b.y - newY) +  (b.x - newX) * (b.x - newX));
								//trace(distToBlock);
								if( distToBlock < Main.BLOCK_WIDTH)
								{
									touching = true;
									break outer;
								}
							}
						}
						
						if(touching)
						{
							//this.x -= moveX;
							//this.y -= moveY;
						}
						else
						{
							
						}
						
						*/

					//view.rotation = radian * 180 / Math.PI;
				}
			}

		}

	}

}

