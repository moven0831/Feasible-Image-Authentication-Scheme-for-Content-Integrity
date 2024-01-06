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


template GrayscaleChecker(hOrig, wOrig) {
    signal input orig_img[hOrig][wOrig][3];
    signal input gray_img[hOrig][wOrig];

    signal output n_check;
 
    signal lt[hOrig][wOrig][2];

    for (var i = 0; i < hOrig; i++) {
        for (var j = 0; j < wOrig; j++) {
            var inter = 30 * orig_img[i][j][0] + 59 * orig_img[i][j][1] + 11 * orig_img[i][j][2];

            lt[i][j][0] <== LessEqThan(16)([inter - 100 * gray_img[i][j], 100]);
            lt[i][j][1] <== LessEqThan(16)([100 * gray_img[i][j] - inter, 100]);

            lt[i][j] === [1, 1];
        }
    }

    n_check <== hOrig * wOrig;
}

component main = GrayscaleChecker(1200, 768);
