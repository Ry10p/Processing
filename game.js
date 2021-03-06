window.onload = function() {	
	var tileSize =  80;
	var numRows = 4;
	var numCols = 5;
	var tileSpacing = 10;
	var tilesArray = [];
	var game = new Phaser.Game(500, 500);
	var playGame = function(game){}
	playGame.prototype = {
		preload: function(){
			game.load.spritesheet("tiles", "tiles.png", tileSize, tileSize);	
		},
		create: function(){
			this.placeTiles();
		},
		placeTiles: function(){
		    	var leftSpace = (game.width - (numCols * tileSize) - ((numCols - 1) * 	tileSpacing))/2;
		    	var topSpace = (game.height - (numRows * tileSize) - ((numRows - 1) * 	tileSpacing))/2;
			for(var i = 0; i < numRows * numCols; i++){
				tilesArray.push(Math.floor(i / 2));
			}
		 	console.log("my tile values: " + tilesArray);
			for(i = 0; i < numCols; i++){
		     	for(var j = 0; j < numRows; j++){  
		          	var tile = game.add.button(leftSpace + i * (tileSize +	tileSpacing), topSpace + j * (tileSize + tileSpacing), "tiles", this.showTile, this);
		               tile.frame = 10;
		               tile.value = tilesArray[j * numCols + i];
		          }   
		     }     
		},
		showTile: function(target){
     		target.frame = target.value;
		}
	}
	game.state.add("PlayGame", playGame);
	game.state.start("PlayGame");
}