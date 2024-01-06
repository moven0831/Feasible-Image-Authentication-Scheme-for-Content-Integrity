pragma circom 2.1.0;


template IsZero() {
     signal input in;
     signal output out;

     signal inv;

     inv <-- in!=0 ? 1/in : 0;
     out <== -in*inv + 1;
     in*out === 0;
}

template CheckBrightness() {
     signal input calcVal;
     signal input actualVal;
     signal input remainder;
     signal input x[6];

     signal output out[3];

     signal isZero1 <== IsZero()(4 * (2545 - calcVal) + 1 - x[0] - x[1] - x[2]);
     signal isZero2 <== IsZero()(4 * (calcVal - 5) + 1 - x[3] - x[4] - x[5]);

     var a = isZero1 + isZero2  - 1;
     var b = 10 * actualVal - calcVal + remainder;

     out <== [(1 - isZero1) * (actualVal - 255), (1 - isZero2) * actualVal, a * b];
}


template Bright(n) {

    signal input orig_img[n][3];
    signal input new_img[n][3];
    signal input squares[n][3][6];
   
    signal input positiveRemainder[n][3];
    signal input negativeRemainder[n][3];
    
    signal input alpha;
    signal input posBeta;
    signal input negBeta;

    signal output n_check;

    signal checkBright[n][3][3];
 
    for (var i = 0; i < n; i++) {
          for (var j = 0; j < 3; j++) {
               checkBright[i][j] <== CheckBrightness()(
                    alpha * orig_img[i][j] + posBeta - negBeta,
                    new_img[i][j],
                    positiveRemainder[i][j] - negativeRemainder[i][j],
                    [
                         squares[i][j][0] * squares[i][j][0],
                         squares[i][j][1] * squares[i][j][1],
                         squares[i][j][2] * squares[i][j][2],
                         squares[i][j][3] * squares[i][j][3],
                         squares[i][j][4] * squares[i][j][4],
                         squares[i][j][5] * squares[i][j][5]
                    ]);
               checkBright[i][j] === [0, 0, 0];
          }
     }
     n_check <== n;
}

component main = Bright(2000);
