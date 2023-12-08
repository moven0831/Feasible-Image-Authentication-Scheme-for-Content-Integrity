pragma circom 2.1.0;


template Num2Bits(n) {
    signal input in;
    signal output out[n];
    var lc1=0;

    var e2=1;
    for (var i = 0; i<n; i++) {
        out[i] <-- (in >> i) & 1;
        out[i] * (out[i] -1 ) === 0;
        lc1 += out[i] * e2;
        e2 = e2+e2;
    }

    lc1 === in;
}


template LessThan(n) {
    assert(n <= 252);
    signal input in[2];
    signal output out;

    component n2b = Num2Bits(n+1);

    n2b.in <== in[0]+ (1<<n) - in[1];

    out <== 1-n2b.out[n];
}


template LessEqThan(n) {
    signal input in[2];
    signal output out;

    component lt = LessThan(n);

    lt.in[0] <== in[0];
    lt.in[1] <== in[1]+1;
    lt.out ==> out;
}


template CheckBrightness() {
    signal input calcVal;
    signal input actualVal;
    signal input remainder;
    signal output out[3];

    signal lt[2];

    lt[0] <== LessEqThan(13)([2545, calcVal]);
    lt[1] <== LessEqThan(13)([calcVal, 5]);

    out[0] <== lt[0] * (actualVal - 255);
    out[1] <== lt[1] * actualVal;
    out[2] <== (1 - out[0] - out[1]) * (10 * actualVal - calcVal + remainder);
}


template Bright(n) {
    signal input orig[n][3];
    signal input new[n][3];
   
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
                alpha * orig[i][j] + posBeta - negBeta,
                new[i][j],
                positiveRemainder[i][j] - negativeRemainder[i][j]);
            checkBright[i][j] === [0, 0, 0];
        }
    }

    
    n_check <== n; 
}

component main = Bright(200);
