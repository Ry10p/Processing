for(i = 0; i < numRows * numCols; i++){
                    var from = game.rnd.between(0,tilesArray.length-1);
                    var to = game.rnd.between(0, tilesArray.length-1);
                    var temp = tilesArray[from];
                    tilesArray[from] = tilesArray[to];
                    tilesArray[to] = temp;
