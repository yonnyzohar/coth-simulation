package {
	import flash.display.MovieClip;
	import flash.events.*;

	public class Main extends MovieClip {
		
		
		public static var SOUTH:int = 1;
		public static var SOUTH_EAST:int = 2;
		public static var EAST:int = 3;
		public static var NORTH_EAST:int = 4;
		public static var NORTH:int = 5;
		public static var NORTH_WEST:int = 6;
		public static var WEST:int = 7;
		public static var SOUTH_WEST:int = 8;
		
		/*
		public static var net:Array = [
			[0,0,0],
			[0,0,0],
			[0,0,0]
		];
			
		
		public static var net: Array = [
			[0, 0, 0, 0, 0],
			[0, 0, 0, 0, 0],
			[0, 0, 0, 0, 0],
			[0, 0, 0, 0, 0],
			[0, 0, 0, 0, 0]
		];
		*/
		
		public static var net: Array = [
			[0, 0, 0, 0, 0, 0, 0],
			[0, 0, 0, 0, 0, 0, 0],
			[0, 0, 0, 0, 0, 0, 0],
			[0, 0, 0, 0, 0, 0, 0],
			[0, 0, 0, 0, 0, 0, 0],
			[0, 0, 0, 0, 0, 0, 0],
			[0, 0, 0, 0, 0, 0, 0]
		];

		var alph: Number = 1;
		public static var BLOCK_WIDTH: Number = 40;
		public static var mainMC:MovieClip;
		var currentBlock:Block;

		

		public function Main() {
			mainMC = this;
			
			for (var row: int = 0; row < net.length; row++) {
				for (var col: int = 0; col < net.length; col++) {
					var b: Block = new Block();
					b.arrowMC.stop();
					b.arrowMC.visible = false;
					b.arrowMC.mouseEnabled = false;
					stage.addChild(b);
					b.x = BLOCK_WIDTH * col;
					b.y = BLOCK_WIDTH * row;
					b.x += stage.stageWidth/2;
					b.y += stage.stageHeight/2;
					b.row = row;
					b.col = col;
					b.myTarget = null;
					net[row][col] = b;
				}
			}
			stage.addEventListener(MouseEvent.MOUSE_DOWN, onDown);
			stage.addEventListener(MouseEvent.MOUSE_UP, onUp);
			stage.addEventListener(Event.ENTER_FRAME, update);
		}
		
		


		function update(e: Event): void {
			this.graphics.clear();
			this.graphics.lineStyle(2, 0x990000, .75);
			for (var row: int = 0; row < net.length; row++) {
				for (var col: int = 0; col < net.length; col++) {
					net[row][col].update();
				}
			}
			
		}
		
	

		function clearAllBlocks(): void {
			alph = 1;

			for (var row: int = 0; row < net.length; row++) {
				for (var col: int = 0; col < net.length; col++) {
					var b: Block = net[row][col];
					b.arrowMC.visible = false;
					b.alpha = 1;
					b.myTarget = null;
				}
			}
		}

		function onUp(e: MouseEvent): void {

			currentBlock.mouseDown = false;
			
		}

		function onDown(e: MouseEvent): void {
			clearAllBlocks();
			var b: Block;
			var shortest:Block;
			
			var mX:int = stage.mouseX;
			var mY:int = stage.mouseY;
			var minDist:int = 10000000;
			for (var _row:int = 0; _row < Main.net.length; _row++) {
				for (var _col:int = 0; _col < Main.net.length; _col++) {
					b = net[_row][_col];
					var distToBlock:Number = Math.sqrt((b.y - mY) * (b.y - mY) +  (b.x - mX) * (b.x - mX));
					if(distToBlock < minDist)
					{
						minDist = distToBlock;
						shortest = b;
						
					}
				}
			}
			
			
			shortest.mouseDown = true;
			shortest.alpha = alph;
			currentBlock = shortest;
			setDependents(shortest, 1);
		}


		function getDistance(p1: Block, p2: Block): Number {
			var dx = p2.x - p1.x;
			var dy = p2.y - p1.y;
			return Math.sqrt((dy * dy) + (dx * dx));
		}

		function setDependents(b: Block, amount: int): void {
			alph -= 0.1
			var baseRow: int = b.row;
			var baseCol: int = b.col;
			var bb: Block;
			var count: int = 0;

			for (var row: int = -amount; row <= amount; row++) {
				for (var col: int = -amount; col <= amount; col++) {
					var proceed: Boolean = false;
					//we only want to run through the outer square
					if (row == -amount || row == amount) {
						proceed = true;
					} else {
						if (col == -amount || col == amount) {
							proceed = true;
						}
					}

					if (proceed) {
						if (net[baseRow + row] && net[baseRow + row][baseCol + col]) {
							bb = net[baseRow + row][baseCol + col];
							if (bb.myTarget == null) {
								var state: int = -1;
								//1,1,
								//1,0
								//if top left, parent is 0 
								if (row == -amount && col == -amount) {
									state = SOUTH_EAST;
									bb.myTarget = net[baseRow + row + 1][baseCol + col + 1];
									bb.xOffest = -BLOCK_WIDTH;
									bb.yOffset = -BLOCK_WIDTH;
									
								} else if (row == -amount && col == -amount + 1) {
									state = SOUTH;
									bb.myTarget = net[baseRow + row + 1][baseCol + col];
									bb.xOffest = 0;
									bb.yOffset = -BLOCK_WIDTH;
									
								} else if (row == -amount + 1 && col == -amount) {
									state = EAST;
									bb.myTarget = net[baseRow + row][baseCol + col + 1];
									bb.xOffest = -BLOCK_WIDTH;
									bb.yOffset = 0;
								}

								//1,1
								//0,1
								//if top right, parent is 0 
								else if (row == -amount && col == amount) {
									state = SOUTH_WEST;
									bb.myTarget = net[baseRow + row + 1][baseCol + col - 1];
									bb.xOffest = BLOCK_WIDTH;
									bb.yOffset = -BLOCK_WIDTH;
									
								} else if (row == -amount + 1 && col == amount) {
									state = WEST;
									bb.myTarget = net[baseRow + row][baseCol + col - 1];
									bb.xOffest = BLOCK_WIDTH;
									bb.yOffset = 0;
									
								} else if (row == -amount && col == amount - 1) {
									state = SOUTH;
									bb.myTarget = net[baseRow + row + 1][baseCol + col];
									bb.xOffest = 0;
									bb.yOffset = -BLOCK_WIDTH;
								}

								//1,0
								//1,1
								//if bottom left
								else if (row == amount && col == -amount) {
									state = NORTH_EAST;
									bb.myTarget = net[baseRow + row - 1][baseCol + col + 1];
									bb.xOffest = -BLOCK_WIDTH;
									bb.yOffset = BLOCK_WIDTH;
									
								} else if (row == amount - 1 && col == -amount) {
									state = EAST;
									bb.myTarget = net[baseRow + row][baseCol + col + 1];
									bb.xOffest = -BLOCK_WIDTH;
									bb.yOffset = 0;
									
								} else if (row == amount && col == -amount + 1) {
									state = NORTH;
									bb.myTarget = net[baseRow + row - 1][baseCol + col];
									bb.xOffest = 0;
									bb.yOffset = BLOCK_WIDTH;
								}

								//0,1
								//1,1
								//if bottom right
								else if (row == amount && col == amount) {
									state = NORTH_WEST;
									bb.myTarget = net[baseRow + row - 1][baseCol + col - 1];
									bb.xOffest = BLOCK_WIDTH;
									bb.yOffset = BLOCK_WIDTH;
									
								} else if (row == amount - 1 && col == amount) {
									state = WEST;
									bb.myTarget = net[baseRow + row][baseCol + col - 1];
									bb.xOffest = BLOCK_WIDTH;
									bb.yOffset = 0;
									
								} else if (row == amount && col == amount - 1) {
									state = NORTH;
									bb.myTarget = net[baseRow + row - 1][baseCol + col];
									bb.xOffest = 0;
									bb.yOffset = BLOCK_WIDTH;
									
								} else {
									if (col == -amount) {
										state = EAST;
										bb.myTarget = net[baseRow + row][baseCol + col + 1];
										bb.xOffest = -BLOCK_WIDTH;
										bb.yOffset = 0;
									}
									if (col == amount) {
										state = WEST;
										bb.myTarget = net[baseRow + row][baseCol + col - 1];
										bb.xOffest = BLOCK_WIDTH;
										bb.yOffset = 0;
									}
									if (row == -amount) {
										state = SOUTH;
										bb.myTarget = net[baseRow + row + 1][baseCol + col];
										bb.xOffest = 0;
										bb.yOffset = -BLOCK_WIDTH;
									}

									if (row == amount) {
										state = NORTH;
										bb.myTarget = net[baseRow + row - 1][baseCol + col];
										bb.xOffest = 0;
										bb.yOffset = BLOCK_WIDTH;
									}
								}
								if (state != -1) {
									bb.arrowMC.visible = true;
									bb.arrowMC.gotoAndStop(state);
								}


								bb.alpha = alph;
								count++;
								//var distance:Number = getDistance(bb, b);
								//b.moveThreshold = ( (distance / BLOCK_WIDTH) );
							}

						}
					}

				}
			}
			if (count > 0) {
				amount++;
				setDependents(b, amount);
			}
		}

	}
}