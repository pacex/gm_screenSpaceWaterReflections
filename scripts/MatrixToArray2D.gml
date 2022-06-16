/// MatrixToArray2D( matrix m, int size );
var Matrix = argument0;
var size   = argument1;
var M2D;
var Counter = 0;
for( var j=0; j<size; j++){
    for( var i=0; i<size; i++ ){
        M2D[i,j] = Matrix[Counter];
        Counter ++;
    }
}
return M2D;

