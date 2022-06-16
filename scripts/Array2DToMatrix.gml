/// Array2DToMatrix( Array a, int size);
var Array = argument0;
var M;
var Counter = 0;
for( var j=0; j<argument1; j++){
    for( var i=0; i<argument1; i++ ){
        M[Counter] = Array[i,j];
        Counter ++;
    }
}
return M;

