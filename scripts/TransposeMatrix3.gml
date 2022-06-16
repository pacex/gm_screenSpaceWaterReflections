/// InverseMatrix4( matrix m )

var Original = MatrixToArray2D( argument0, 3 );
var Result;

Result[0,0] = Original[0,0];
Result[0,1] = Original[1,0];
Result[0,2] = Original[2,0];
Result[1,0] = Original[0,1];
Result[1,1] = Original[1,1];
Result[1,2] = Original[2,1];
Result[2,0] = Original[0,2];
Result[2,1] = Original[1,2];
Result[2,2] = Original[2,2];

return Array2DToMatrix( Result, 3 );

