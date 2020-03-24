//game of life
let w;
let columns;
let rows;
let board;
let temp;
function setup(){
    var cnv = createCanvas(1000,600);
    cnv.parent('canvas');
    frameRate(5);
    w = 20;
    // calculate columns and rows
    columns = floor(width/w);
    rows = floor(height/w);
    // make a 2d array
    board = new Array(columns);
    for (let i=0; i<columns; i++){
        board[i] = new Array(rows);
    }
    temp = new Array(columns);
    for (let i=0; i<columns; i++){
        temp[i] = new Array(rows);
    }
    init();
}

function draw(){
    background(255);
    generate();
    drawTheBoard();
}

// draw the 'board'
function drawTheBoard(){
    for (let i=0; i<columns; i++){
    for (let j=0; j<rows; j++){
        if (board[i][j]==1) fill(0);
        else fill(255);
        stroke(0);
        rect(i*w,j*w,w-1,w-1);
    }
    }
}

// reset board when mouse is pressed
function mousePressed() {
    init();
    drawTheBoard();
}

// fill board randomlly
function init(){
    for (let i=0; i<columns; i++){
    for (let j=0; j<rows; j++){
        if(i==0||j==0||i==columns-1||j==rows-1) board[i][j]=0;
        else board[i][j] = floor(random(2));
    }
    }
    board[5][5] = 1;
    board[5][6] = 1;
    board[5][7] = 1;
}

// create new generation
function generate(){
    for (let i=0; i<columns; i++){
    for (let j=0; j<rows; j++){
        temp[i][j] = board[i][j];
    }
    }
    for (let x=1; x<columns-1; x++){
    for (let y=1; y<rows-1; y++){
        let neighbors = 0;
        for (let i=-1; i<=1; i++){
            for (let j=-1; j<=1; j++){
                neighbors+=temp[x+i][y+j];
            }
        }
        neighbors-=temp[x][y];
        if      (neighbors==2) board[x][y]+=0;
        else if (neighbors==3) board[x][y]=1;
        else board[x][y] = 0;
    }
    }
}