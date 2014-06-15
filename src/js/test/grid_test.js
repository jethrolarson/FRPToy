//require grid
var grid = Grid({},10,10);

console.log('Grid.set')
Grid.set(grid,3,2,1);
console.log('Grid.get');
console.assert(Grid.get(grid,3,2) == 1);

console.log('Grid.isAdjacent');
console.assert(Grid.isAdjacent(grid, 3,2,3,3) == true);
console.assert(Grid.isAdjacent(grid, 3,2,3,4) == false);
console.assert(Grid.isAdjacent(grid, 2,3,3,3) == true);
console.assert(Grid.isAdjacent(grid, 2,2,3,3) == false);
 
console.log('Grid.isDiagonal');
console.assert(Grid.isDiagonal(grid, 2,2,3,3) == true);
console.assert(Grid.isDiagonal(grid, 2,2,3,2) == false);
console.assert(Grid.isDiagonal(grid, 3,2,2,3) == true);

console.log('Grid.difference'); 
console.assert(Grid.difference(grid, 0,0,3,3) == 6);
console.assert(Grid.difference(grid, 2,2,3,2) == 1);
console.assert(Grid.difference(grid, 3,2,2,3) == 2);

