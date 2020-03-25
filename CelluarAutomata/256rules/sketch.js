//256 rules
let w = 2;
let columns = 128*w;
let rows = 128*w;
let board;
let ruleNumber;
let ruleArray
let slider
function setup(){
    var cnv = createCanvas(columns*w,rows*w);
    cnv.parent('canvas');
    frameRate(5);
    // make a 2d array
    board = new Array(columns);
    for (let i=0; i<columns; i++){
        board[i] = new Array(rows);
    }

    slider = createSlider(0, 255, 30, 1);
    slider.parent('slider');
    // slider.style('width', '500 px');
    slider.size(128*3,10);
    ruleNumber = 1000;
    
    ruleArray = new Array(8);
}

function draw(){
    let tmp = slider.value();
    if (slider.value()!=ruleNumber){
        background(255);
        generateBoard();
        drawBoard();
    }
}

function drawBoard(){
    
    id = document.getElementById("sliderText");
    ruleNumber = slider.value();
    id.innerHTML = "RULES: "+ruleNumber;
    
    for (let i=0; i<columns; i++){
    for (let j=0; j<rows; j++){
        if (board[i][j]==1) fill(0);
        else fill(255);
        noStroke();
        rect(i*w,j*w,w-0.1,w-0.1);
    }
    }
}

function generateBoard(){
    for (let i=0; i<columns; i++){
    for (let j=0; j<rows; j++){
        if(j==0) board[i][j] = floor(random(2));
        else board[i][j] = 0;
    }
    }

    for (let i=0; i<8; i++){
        ruleArray[i] = 0;
    }
    
    let tmp = slider.value();
    let kk = 7;
    while(tmp!=0){
        ruleArray[kk] = tmp%2;
        tmp = parseInt(tmp/2);
        kk = kk - 1;
    }
    
    for (let j=1; j<rows; j++){
    for (let i=0; i<columns; i++){
        let L = i-1;
        let R = i+1;
        if(L==-1) L=columns-1;
        if(R==columns) R=0;
        let a=board[L][j-1];
        let b=board[i][j-1];
        let c=board[R][j-1];
        board[i][j] = rules(a,b,c);
    }
    }
}


function rules(a,b,c){
    
    if(a==1&&b==1&&c==1) return ruleArray[0];
    if(a==1&&b==1&&c==0) return ruleArray[1];
    if(a==1&&b==0&&c==1) return ruleArray[2];
    if(a==1&&b==0&&c==0) return ruleArray[3];
    if(a==0&&b==1&&c==1) return ruleArray[4];
    if(a==0&&b==1&&c==0) return ruleArray[5];
    if(a==0&&b==0&&c==1) return ruleArray[6];
    if(a==0&&b==0&&c==0) return ruleArray[7];
}

