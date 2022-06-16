/// InverseMatrix3( matrix m )

var Original = MatrixToArray2D( argument0, 3 );
var Result;
var tmp;

var det = Original[0,0] * Original[1,1] * Original[2,2]
        + Original[0,1] * Original[1,2] * Original[2,0]
        + Original[0,2] * Original[1,0] * Original[2,1]
        - Original[0,0] * Original[1,2] * Original[2,1]
        - Original[0,1] * Original[1,0] * Original[2,2]
        - Original[0,2] * Original[1,1] * Original[2,0];

var inv_det = 1.0 / det;

tmp[0,0] = Original[1,1] * Original[2,2] - Original[2,1] * Original[1,2];
tmp[1,0] = Original[2,0] * Original[1,2] - Original[1,0] * Original[2,2];
tmp[2,0] = Original[1,0] * Original[2,1] - Original[2,0] * Original[1,1];
tmp[0,1] = Original[2,1] * Original[0,2] - Original[0,1] * Original[2,2];
tmp[1,1] = Original[0,0] * Original[2,2] - Original[2,0] * Original[0,2];
tmp[2,1] = Original[2,0] * Original[0,1] - Original[0,0] * Original[2,1];
tmp[0,2] = Original[0,1] * Original[1,2] - Original[1,1] * Original[0,2];
tmp[1,2] = Original[1,0] * Original[0,2] - Original[0,0] * Original[1,2];
tmp[2,2] = Original[0,0] * Original[1,1] - Original[1,0] * Original[0,1];
    
Result[0,0] = inv_det * tmp[0,0];
Result[1,0] = inv_det * tmp[1,0];
Result[2,0] = inv_det * tmp[2,0];
Result[0,1] = inv_det * tmp[0,1];
Result[1,1] = inv_det * tmp[1,1];
Result[2,1] = inv_det * tmp[2,1];
Result[0,2] = inv_det * tmp[0,2];
Result[1,2] = inv_det * tmp[1,2];
Result[2,2] = inv_det * tmp[2,2];

return Array2DToMatrix( Result, 3 );

