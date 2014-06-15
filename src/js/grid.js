Grid = function(cxt, cols, rows){
    "use Strict";
    var i, j, col,
        defaultCellValue = 0;

    cxt.gridCols = cols;
    cxt.gridRows = rows;
    cxt.grid = [];
    for(i = 0; i < cols; i++){
        col = [];
        for(j = 0; j < rows; j++){
            col.push(defaultCellValue);
        }
        cxt.grid.push(col);
    }
    return cxt;
};

Grid.set = function(cxt, col, row, val) {
    cxt.grid[col][row] = val;
    return cxt;
};

Grid.get = function(cxt, col, row) {
    return cxt.grid[col][row];
};

Grid.isAdjacent = function(cxt, col1, row1, col2, row2) {
    return Grid.difference.apply(cxt, slice(arguments)) == 1;
};

Grid.isDiagonal = function(cxt, col1, row1, col2, row2) {
    return Math.abs(row1-row2) == 1 && Math.abs(col1-col2) == 1;
};

Grid.difference = function(cxt, col1,row1,col2,row2) {
    return Math.abs(row1-row2) + Math.abs(col1-col2);
};
