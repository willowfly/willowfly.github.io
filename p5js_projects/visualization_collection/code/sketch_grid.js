let cols; 
let rows; 
let spacing = 20; 
let size = [];

function setup() {
    createCanvas(400, 400);
    rectMode(CENTER);
    cols = width/spacing;
    rows = height/spacing;
    for (let i=0; i<cols; i++){
        size[i] = [];
        for (let j=0; j<rows; j++){
            size[i][j] = 10;
        }
    }
}

function draw() {
    background(0);
    noStroke();
    for (let i=0; i<cols; i++){
        for (let j=0; j<rows; j++){
            s = dist(mouseX,mouseY,
                i*spacing+spacing/2,j*spacing+spacing/2
            );
            size[i][j] = map(s, 0, 200, 0, 20);
        }
    }
    for(let i=0; i<cols; i++){
        for(let j=0; j<rows; j++){
            rect( spacing/2+i*spacing, spacing/2+j*spacing,
                size[i][j],size[i][j] );
        }
    }
}

